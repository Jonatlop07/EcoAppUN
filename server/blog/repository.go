package blog

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type BlogFilter struct {
	Categories []string
	CreatedAt  time.Time
	Title      string
}

type BlogRepository interface {
	Create(articleDetails ArticleDetails) (Article, error)
	GetByID(id string) (*Article, error)
	GetAll(filter BlogFilter) ([]Article, error)
	Update(article Article) (Article, error)
	Delete(id string) error
	AddReaction(articleId string, reactionDetails ArticleReactionDetails) (ArticleReaction, error)
	RemoveReaction(articleID string, authorID string) error
	CreateComment(articleId string, commentDetails CommentDetails) (Comment, error)
	DeleteComment(articleID string, commentID string) error
	AddReactionToComment(idx CommentIdentifiersDTO, reactionDetails CommentReactionDetails) (CommentReaction, error)
	RemoveReactionFromComment(idx CommentIdentifiersDTO, authorID string) error
}

type MongoDBBlogRepository struct {
	Collection *mongo.Collection
}

func (r *MongoDBBlogRepository) Create(articleDetails ArticleDetails) (Article, error) {
	article := FromDetails(articleDetails)
	articleModel := FromArticle(article)
	_, err := r.Collection.InsertOne(context.TODO(), articleModel)
	if err != nil {
		return Article{}, err
	}
	return article, nil
}

func (r *MongoDBBlogRepository) GetByID(id string) (*Article, error) {
	var article Article
	filter := bson.M{"id": id}
	err := r.Collection.FindOne(context.TODO(), filter).Decode(&article)
	if err != nil {
		return nil, err
	}
	return &article, nil
}

func (repo *MongoDBBlogRepository) GetAll(filter BlogFilter) ([]Article, error) {
	query := bson.M{}
	if filter.Categories != nil && len(filter.Categories) > 0 {
		query["category"] = bson.M{"$in": filter.Categories}
	}
	if !filter.CreatedAt.IsZero() {
		query["createdAt"] = bson.M{"$gte": filter.CreatedAt}
	}
	if filter.Title != "" {
		query["title"] = bson.M{"$regex": filter.Title, "$options": "i"}
	}
	cursor, err := repo.Collection.Find(context.TODO(), query)
	if err != nil {
		return nil, err
	}
	defer cursor.Close(context.TODO())
	var articles []Article
	if err := cursor.All(context.TODO(), &articles); err != nil {
		return nil, err
	}
	if articles == nil {
		articles = []Article{}
	}
	return articles, nil
}

func (r *MongoDBBlogRepository) Update(article Article) (Article, error) {
	articleModel := FromArticle(article)
	articleModel.UpdatedAt = time.Now()
	filter := bson.M{"id": article.ID}
	update := bson.M{"$set": articleModel}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return Article{}, err
	}
	return FromArticleModel(articleModel), nil
}

func (r *MongoDBBlogRepository) Delete(id string) error {
	filter := bson.M{"id": id}
	_, err := r.Collection.DeleteOne(context.TODO(), filter)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBBlogRepository) AddReaction(articleId string, reactionDetails ArticleReactionDetails) (ArticleReaction, error) {
	r.RemoveReaction(articleId, reactionDetails.AuthorID)
	reaction := FromArticleReactionDetails(reactionDetails)
	reactionModel := FromArticleReaction(reaction)
	filter := bson.M{"id": articleId}
	update := bson.M{"$push": bson.M{"reactions": reactionModel}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return ArticleReaction{}, err
	}
	return reaction, nil
}

func (r *MongoDBBlogRepository) RemoveReaction(articleId string, authorId string) error {
	filter := bson.M{"id": articleId, "reactions.authorId": authorId}
	update := bson.M{"$pull": bson.M{"reactions": bson.M{"authorId": articleId}}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBBlogRepository) CreateComment(articleId string, commentDetails CommentDetails) (Comment, error) {
	comment := FromCommentDetails(commentDetails)
	commentModel := FromComment(comment)
	filter := bson.M{"id": articleId}
	update := bson.M{"$push": bson.M{"comments": commentModel}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return Comment{}, err
	}
	return comment, nil
}

func (r *MongoDBBlogRepository) DeleteComment(articleID string, commentID string) error {
	filter := bson.M{"id": articleID}
	update := bson.M{"$pull": bson.M{"comments": bson.M{"id": commentID}}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBBlogRepository) AddReactionToComment(
	idx CommentIdentifiersDTO,
	reactionDetails CommentReactionDetails,
) (CommentReaction, error) {
	r.RemoveReactionFromComment(idx, reactionDetails.AuthorID)
	reaction := FromCommentReactionDetails(reactionDetails)
	reactionModel := FromCommentReaction(reaction)
	reaction.CreatedAt = time.Now()
	filter := bson.M{"id": idx.ArticleID, "comments.id": idx.CommentID}
	update := bson.M{"$push": bson.M{"comments.$.reactions": reactionModel}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return CommentReaction{}, err
	}
	return reaction, nil
}

func (r *MongoDBBlogRepository) RemoveReactionFromComment(idx CommentIdentifiersDTO, authorID string) error {
	filter := bson.M{"id": idx.ArticleID, "comments.id": idx.CommentID}
	update := bson.M{"$pull": bson.M{"comments.$.reactions": bson.M{"authorId": authorID}}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func ProvideBlogRepository(database *mongo.Database) BlogRepository {
	return &MongoDBBlogRepository{
		Collection: database.Collection("articles"),
	}
}
