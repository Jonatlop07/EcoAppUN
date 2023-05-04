package blog

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type BlogController struct {
	Gateway BlogRepository
}

func (c *BlogController) CreateArticle(ctx *gin.Context) {
	var article Article
	if err := ctx.ShouldBindJSON(&article); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := c.Gateway.Create(&article)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, article)
}

func (c *BlogController) GetArticleByID(ctx *gin.Context) {
	id := ctx.Param("id")
	article, err := c.Gateway.GetByID(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if article == nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Article not found"})
		return
	}
	ctx.JSON(http.StatusOK, article)
}

func (c *BlogController) GetAllArticles(ctx *gin.Context) {
	articles, err := c.Gateway.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, articles)
}

func (c *BlogController) UpdateArticle(ctx *gin.Context) {
	id := ctx.Param("id")
	var article Article
	if err := ctx.ShouldBindJSON(&article); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	article.ID = id
	err := c.Gateway.Update(&article)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, article)
}

func (c *BlogController) DeleteArticle(ctx *gin.Context) {
	id := ctx.Param("id")
	err := c.Gateway.Delete(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Article deleted successfully"})
}

func (c *BlogController) AddReactionToArticle(ctx *gin.Context) {
	articleID := ctx.Param("id")
	var reaction ArticleReaction
	if err := ctx.ShouldBindJSON(&reaction); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := c.Gateway.AddReaction(articleID, &reaction)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Reaction added successfully"})
}

func (controller *BlogController) RemoveReactionFromArticle(ctx *gin.Context) {
	articleID := ctx.Param("id")
	userID := ctx.Param("user_id")

	err := controller.Gateway.RemoveReaction(articleID, userID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"message": "Reaction removed successfully"})
}

func (c *BlogController) CreateArticleComment(ctx *gin.Context) {
	articleID := ctx.Param("id")
	var comment Comment
	if err := ctx.ShouldBindJSON(&comment); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := c.Gateway.CreateComment(articleID, &comment)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, comment)
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
	var reaction CommentReaction
	reaction.CommentID = commentID
	if err := ctx.ShouldBindJSON(&reaction); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := controller.Gateway.AddReactionToComment(articleID, &reaction)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Reaction added to comment successfully"})
}

func (controller *BlogController) RemoveReactionFromComment(ctx *gin.Context) {
	articleID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	userID := ctx.Param("user_id")
	err := controller.Gateway.RemoveReactionFromComment(articleID, commentID, userID)
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
