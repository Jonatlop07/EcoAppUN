package blog

import "github.com/gin-gonic/gin"

func SetupBlogRoutes(router *gin.Engine, blogController *BlogController) {
	blogGroup := router.Group("/articles")
	{
		blogGroup.GET("", blogController.GetAllArticles)
		blogGroup.POST("", blogController.CreateArticle)
		blogGroup.GET("/:id", blogController.GetArticleByID)
		blogGroup.PUT("/:id", blogController.UpdateArticle)
		blogGroup.DELETE("/:id", blogController.DeleteArticle)
		blogGroup.PATCH("/:id/reactions/", blogController.AddReactionToArticle)
		blogGroup.DELETE("/:id/reactions/:user_id", blogController.RemoveReactionFromArticle)
		blogGroup.PATCH("/:id/comments/", blogController.CreateArticleComment)
		blogGroup.DELETE("/:id/comments/:comment_id", blogController.DeleteArticleComment)
		blogGroup.PATCH("/:id/comments/:comment_id/reactions", blogController.AddReactionToComment)
		blogGroup.DELETE("/:id/comments/:comment_id/reactions/:user_id", blogController.RemoveReactionFromComment)
	}
}
