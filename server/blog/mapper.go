package blog

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func FromDetails(articleDetails ArticleDetails) Article {
	articleID := primitive.NewObjectID().Hex()
	return Article{
		ID:         articleID,
		AuthorID:   articleDetails.AuthorID,
		Title:      articleDetails.Title,
		Content:    articleDetails.Content,
		Categories: articleDetails.Categories,
		CreatedAt:  time.Now(),
		UpdatedAt:  time.Now(),
		Comments:   []Comment{},
		Reactions:  []ArticleReaction{},
	}
}

func FromArticleReactionDetails(reactionDetails ArticleReactionDetails) ArticleReaction {
	return ArticleReaction{
		AuthorID:  reactionDetails.AuthorID,
		Type:      reactionDetails.Type,
		CreatedAt: time.Now(),
	}
}

func FromCommentDetails(commentDetails CommentDetails) Comment {
	commentID := primitive.NewObjectID().Hex()
	return Comment{
		ID:        commentID,
		AuthorID:  commentDetails.AuthorID,
		Content:   commentDetails.Content,
		CreatedAt: time.Now(),
		Reactions: []CommentReaction{},
	}
}

func FromCommentReactionDetails(reactionDetails CommentReactionDetails) CommentReaction {
	return CommentReaction{
		AuthorID:  reactionDetails.AuthorID,
		Type:      reactionDetails.Type,
		CreatedAt: time.Now(),
	}
}

func FromArticle(article Article) ArticleModel {
	articleId, _ := primitive.ObjectIDFromHex(article.ID)
	authorId, _ := primitive.ObjectIDFromHex(article.AuthorID)
	modelReactions := []ArticleReactionModel{}
	modelComments := []CommentModel{}
	for _, reaction := range article.Reactions {
		modelReactions = append(modelReactions, FromArticleReaction(reaction))
	}
	for _, comment := range article.Comments {
		modelComments = append(modelComments, FromComment(comment))
	}
	return ArticleModel{
		ID:         articleId,
		AuthorID:   authorId,
		Title:      article.Title,
		Content:    article.Content,
		CreatedAt:  article.CreatedAt,
		UpdatedAt:  article.UpdatedAt,
		Categories: article.Categories,
		Reactions:  modelReactions,
		Comments:   modelComments,
	}
}

func FromArticleReaction(reaction ArticleReaction) ArticleReactionModel {
	authorId, _ := primitive.ObjectIDFromHex(reaction.AuthorID)
	return ArticleReactionModel{
		AuthorID:  authorId,
		Type:      reaction.Type,
		CreatedAt: reaction.CreatedAt,
	}
}

func FromComment(comment Comment) CommentModel {
	var commentId primitive.ObjectID
	if comment.ID != "" {
		commentId, _ = primitive.ObjectIDFromHex(comment.ID)
	} else {
		commentId = primitive.NewObjectID()
	}
	authorId, _ := primitive.ObjectIDFromHex(comment.AuthorID)
	modelReactions := []CommentReactionModel{}
	for _, reaction := range comment.Reactions {
		modelReactions = append(modelReactions, FromCommentReaction(reaction))
	}
	return CommentModel{
		ID:        commentId,
		AuthorID:  authorId,
		Content:   comment.Content,
		CreatedAt: comment.CreatedAt,
		Reactions: modelReactions,
	}
}

func FromCommentReaction(reaction CommentReaction) CommentReactionModel {
	authorId, _ := primitive.ObjectIDFromHex(reaction.AuthorID)
	return CommentReactionModel{
		AuthorID:  authorId,
		Type:      reaction.Type,
		CreatedAt: reaction.CreatedAt,
	}
}

func FromArticleModel(articleModel ArticleModel) Article {
	reactions := []ArticleReaction{}
	comments := []Comment{}
	for _, reactionModel := range articleModel.Reactions {
		reactions = append(reactions, FromArticleReactionModel(reactionModel))
	}
	for _, commentModel := range articleModel.Comments {
		comments = append(comments, FromCommentModel(commentModel))
	}
	return Article{
		ID:         articleModel.ID.Hex(),
		AuthorID:   articleModel.AuthorID.Hex(),
		Title:      articleModel.Title,
		Content:    articleModel.Content,
		CreatedAt:  articleModel.CreatedAt,
		UpdatedAt:  articleModel.UpdatedAt,
		Categories: articleModel.Categories,
		Reactions:  reactions,
		Comments:   comments,
	}
}

func FromArticleReactionModel(articleReactionModel ArticleReactionModel) ArticleReaction {
	return ArticleReaction{
		AuthorID:  articleReactionModel.AuthorID.Hex(),
		Type:      articleReactionModel.Type,
		CreatedAt: articleReactionModel.CreatedAt,
	}
}

func FromCommentModel(commentModel CommentModel) Comment {
	reactions := []CommentReaction{}
	for _, reactionModel := range commentModel.Reactions {
		reactions = append(reactions, FromCommentReactionModel(reactionModel))
	}
	return Comment{
		ID:        commentModel.ID.Hex(),
		AuthorID:  commentModel.AuthorID.Hex(),
		Content:   commentModel.Content,
		CreatedAt: commentModel.CreatedAt,
		Reactions: reactions,
	}
}

func FromCommentReactionModel(reactionModel CommentReactionModel) CommentReaction {
	return CommentReaction{
		AuthorID:  reactionModel.AuthorID.Hex(),
		Type:      reactionModel.Type,
		CreatedAt: reactionModel.CreatedAt,
	}
}
