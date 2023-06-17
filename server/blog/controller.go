package blog

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/mongo"
)

type BlogController struct {
	Gateway BlogRepository
}

func (c *BlogController) CreateArticle(ctx *gin.Context) {
	var articleDetails ArticleDetails
	if err := ctx.ShouldBindJSON(&articleDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	createdArticle, err := c.Gateway.Create(articleDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"article_id": createdArticle.ID})
}

func (c *BlogController) GetArticleByID(ctx *gin.Context) {
	id := ctx.Param("id")
	article, err := c.Gateway.GetByID(id)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Article not found"})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"article": article})
}

func (c *BlogController) GetAllArticles(ctx *gin.Context) {
	var filter struct {
		Categories []string  `form:"categories"`
		CreatedAt  time.Time `form:"created_at"`
		Title      string    `form:"title"`
	}
	if err := ctx.ShouldBindQuery(&filter); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	articles, err := c.Gateway.GetAll(BlogFilter{
		Categories: filter.Categories,
		CreatedAt:  filter.CreatedAt,
		Title:      filter.Title,
	})
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"articles": articles})
}

func (c *BlogController) UpdateArticle(ctx *gin.Context) {
	id := ctx.Param("id")
	var article Article
	if err := ctx.ShouldBindJSON(&article); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	article.ID = id
	updatedArticle, err := c.Gateway.Update(article)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"article_id": updatedArticle.ID})
}

func (c *BlogController) DeleteArticle(ctx *gin.Context) {
	id := ctx.Param("id")
	err := c.Gateway.Delete(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (c *BlogController) AddReactionToArticle(ctx *gin.Context) {
	articleID := ctx.Param("id")
	var reactionDetails ArticleReactionDetails
	if err := ctx.ShouldBindJSON(&reactionDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := c.Gateway.AddReaction(articleID, reactionDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Reaction added successfully"})
}

func (controller *BlogController) RemoveReactionFromArticle(ctx *gin.Context) {
	articleID := ctx.Param("id")
	authorID := ctx.Param("author_id")
	err := controller.Gateway.RemoveReaction(articleID, authorID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"message": "Reaction removed successfully"})
}

func (c *BlogController) CreateArticleComment(ctx *gin.Context) {
	articleID := ctx.Param("id")
	var commentDetails CommentDetails
	if err := ctx.ShouldBindJSON(&commentDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	createdComment, err := c.Gateway.CreateComment(articleID, commentDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"comment_id": createdComment.ID})
}

func (controller *BlogController) DeleteArticleComment(ctx *gin.Context) {
	articleID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	err := controller.Gateway.DeleteComment(articleID, commentID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Comment deleted successfully"})
}

func (controller *BlogController) AddReactionToComment(ctx *gin.Context) {
	articleID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	var reactionDetails CommentReactionDetails
	if err := ctx.ShouldBindJSON(&reactionDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := controller.Gateway.AddReactionToComment(CommentIdentifiersDTO{ArticleID: articleID, CommentID: commentID}, reactionDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Reaction added to comment successfully"})
}

func (controller *BlogController) RemoveReactionFromComment(ctx *gin.Context) {
	articleID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	authorID := ctx.Param("author_id")
	err := controller.Gateway.RemoveReactionFromComment(
		CommentIdentifiersDTO{ArticleID: articleID, CommentID: commentID},
		authorID,
	)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Reaction removed from comment successfully"})
}

func ProvideBlogController(blogRepository BlogRepository) *BlogController {
	return &BlogController{
		Gateway: blogRepository,
	}
}
