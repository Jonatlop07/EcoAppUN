package blog

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type BlogRepository interface {
	Create(article *Article) error
	GetByID(id string) (*Article, error)
	GetAll() ([]*Article, error)
	Update(article *Article) error
	Delete(id string) error
	AddReaction(articleID string, reaction *ArticleReaction) error
	RemoveReaction(articleID string, userID string) error
	CreateComment(articleID string, comment *Comment) error
	DeleteComment(articleID string, commentID string) error
	AddReactionToComment(articleID string, reaction *CommentReaction) error
	RemoveReactionFromComment(articleID string, commentID, reactionID string) error
}

type MongoDBBlogRepository struct {
	Collection *mongo.Collection
}

func (r *MongoDBBlogRepository) Create(article *Article) error {
	article.ID = primitive.NewObjectID().Hex()
	article.CreatedAt = time.Now()
	article.UpdatedAt = time.Now()
	_, err := r.Collection.InsertOne(context.TODO(), article)
	if err != nil {
		return err
	}
	return nil
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

func (r *MongoDBBlogRepository) GetAll() ([]*Article, error) {
	var articles []*Article
	cursor, err := r.Collection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cursor.Close(context.TODO())
	for cursor.Next(context.TODO()) {
		var article Article
		if err := cursor.Decode(&article); err != nil {
			return nil, err
		}
		articles = append(articles, &article)
	}
	if err := cursor.Err(); err != nil {
		return nil, err
	}
	return articles, nil
}

func (r *MongoDBBlogRepository) Update(article *Article) error {
	article.UpdatedAt = time.Now()
	filter := bson.M{"id": article.ID}
	update := bson.M{"$set": article}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBBlogRepository) Delete(id string) error {
	filter := bson.M{"id": id}
	_, err := r.Collection.DeleteOne(context.TODO(), filter)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBBlogRepository) AddReaction(articleID string, reaction *ArticleReaction) error {
	r.RemoveReaction(articleID, reaction.UserID)
	filter := bson.M{"id": articleID}
	update := bson.M{"$push": bson.M{"reactions": reaction}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBBlogRepository) RemoveReaction(articleID string, userID string) error {
	filter := bson.M{"id": articleID, "reactions.userId": userID}
	update := bson.M{"$pull": bson.M{"reactions": bson.M{"userId": userID}}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBBlogRepository) CreateComment(articleID string, comment *Comment) error {
	filter := bson.M{"id": articleID}
	update := bson.M{"$push": bson.M{"comments": comment}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
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

func (r *MongoDBBlogRepository) AddReactionToComment(articleID string, reaction *CommentReaction) error {
	filter := bson.M{"id": articleID, "comments.id": reaction.CommentID}
	update := bson.M{"$push": bson.M{"comments.$.reactions": reaction}}
	_, err := r.Collection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBBlogRepository) RemoveReactionFromComment(articleID string, commentID string, reactionID string) error {
	filter := bson.M{"id": articleID, "comments.id": commentID}
	update := bson.M{"$pull": bson.M{"comments.$.reactions": bson.M{"id": reactionID}}}
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
