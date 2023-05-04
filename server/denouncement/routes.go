package denouncement

import "github.com/gin-gonic/gin"

func SetupDenouncementRoutes(router *gin.Engine, denouncementController *DenouncementController) {
	denouncementGroup := router.Group("/denouncements")
	{
		denouncementGroup.GET("", denouncementController.GetAllDenouncements)
		denouncementGroup.POST("", denouncementController.CreateDenouncement)
		denouncementGroup.GET("/:id", denouncementController.GetDenouncementByID)
		denouncementGroup.DELETE("/:id", denouncementController.DeleteDenouncement)
		denouncementGroup.PUT("/:id", denouncementController.UpdateDenouncement)
		denouncementGroup.PATCH("/:id/comments/", denouncementController.CreateComment)
		denouncementGroup.DELETE("/:id/comments/:comment_id", denouncementController.DeleteComment)
		denouncementGroup.PATCH("/:id/comments/:comment_id/responses", denouncementController.CreateCommentResponse)
		denouncementGroup.DELETE("/:id/comments/:comment_id/responses/:response_id", denouncementController.DeleteCommentResponse)
		denouncementGroup.PATCH("/:id/comments/:comment_id/reactions", denouncementController.CreateCommentReaction)
		denouncementGroup.DELETE("/:id/comments/:comment_id/reactions/:user_id", denouncementController.DeleteCommentReaction)
		denouncementGroup.PATCH("/:id/comments/:comment_id/responses/:response_id/reactions/", denouncementController.CreateCommentResponseReaction)
		denouncementGroup.DELETE("/:id/comments/:comment_id/responses/:response_id/reactions/:user_id", denouncementController.DeleteCommentResponseReaction)
	}
}
