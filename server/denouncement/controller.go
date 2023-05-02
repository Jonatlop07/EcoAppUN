package denouncement

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"go.mongodb.org/mongo-driver/mongo"
)

type DenouncementController struct {
	Gateway DenouncementRepository
}

func (denouncementController *DenouncementController) CreateDenouncement(ctx *gin.Context) {
	var denouncement Denouncement
	if err := ctx.ShouldBindJSON(&denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	if err := denouncementController.Gateway.Create(&denouncement); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, denouncement)
}

func (denouncementController *DenouncementController) UpdateDenouncement(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	var denouncement Denouncement
	if err := ctx.ShouldBindJSON(&denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	denouncement.ID = denouncementID
	validate := validator.New()
	if err := validate.Struct(denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	if err := denouncementController.Gateway.Update(&denouncement); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, denouncement)
}

func (denouncementController *DenouncementController) DeleteDenouncement(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	if err := denouncementController.Gateway.Delete(denouncementID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (denouncementController *DenouncementController) GetDenouncementByID(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	denouncement, err := denouncementController.Gateway.GetByID(denouncementID)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Denouncement not found"})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}
	ctx.JSON(http.StatusOK, denouncement)
}

func (denouncementController *DenouncementController) GetAllDenouncements(ctx *gin.Context) {
	denouncements, err := denouncementController.Gateway.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, denouncements)
}

func (denouncementController *DenouncementController) CreateComment(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	var comment Comment
	if err := ctx.ShouldBindJSON(&comment); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	comment.DenouncementID = denouncementID
	if err := denouncementController.Gateway.CreateComment(&comment); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, comment)
}

func (denouncementController *DenouncementController) DeleteComment(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	comment := &Comment{
		ID:             commentID,
		DenouncementID: denouncementID,
	}
	if err := denouncementController.Gateway.DeleteComment(comment); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Comment deleted successfully"})
}

func (denouncementController *DenouncementController) CreateCommentResponse(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	var response Response
	if err := ctx.ShouldBindJSON(&response); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	response.DenouncementID = denouncementID
	response.CommentID = commentID
	if err := denouncementController.Gateway.CreateResponse(&response); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, response)
}

func (denouncementController *DenouncementController) DeleteCommentResponse(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	responseID := ctx.Param("response_id")
	response := &Response{
		ID:             responseID,
		DenouncementID: denouncementID,
		CommentID:      commentID,
	}
	if err := denouncementController.Gateway.DeleteResponse(response); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Response deleted successfully"})
}

func (denouncementController *DenouncementController) CreateCommentReaction(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	var reaction CommentReaction
	if err := ctx.ShouldBindJSON(&reaction); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	reaction.DenouncementID = denouncementID
	reaction.CommentID = commentID
	if err := denouncementController.Gateway.CreateCommentReaction(&reaction); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, reaction)
}

func (denouncementController *DenouncementController) DeleteCommentReaction(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	reactionID := ctx.Param("reaction_id")
	reaction := &CommentReaction{
		ID:             reactionID,
		DenouncementID: denouncementID,
		CommentID:      commentID,
	}
	if err := denouncementController.Gateway.DeleteCommentReaction(reaction); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Comment reaction deleted successfully"})
}

func (denouncementController *DenouncementController) CreateCommentResponseReaction(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	responseID := ctx.Param("response_id")
	var reaction ResponseReaction
	if err := ctx.ShouldBindJSON(&reaction); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	reaction.DenouncementID = denouncementID
	reaction.CommentID = commentID
	reaction.ResponseID = responseID
	if err := denouncementController.Gateway.CreateResponseReaction(&reaction); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, reaction)
}

func (denouncementController *DenouncementController) DeleteCommentResponseReaction(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	responseID := ctx.Param("response_id")
	userID := ctx.Param("user_id")
	reaction := &ResponseReaction{
		UserID:         userID,
		DenouncementID: denouncementID,
		CommentID:      commentID,
		ResponseID:     responseID,
	}
	if err := denouncementController.Gateway.DeleteResponseReaction(reaction); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Response reaction deleted successfully"})
}

func ProvideDenouncementController(denouncementRepository DenouncementRepository) *DenouncementController {
	return &DenouncementController{
		Gateway: denouncementRepository,
	}
}
