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

func (controller *DenouncementController) CreateDenouncement(ctx *gin.Context) {
	var denouncementDetails DenouncementDetails
	if err := ctx.ShouldBindJSON(&denouncementDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(denouncementDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	denouncementID, err := controller.Gateway.Create(denouncementDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, gin.H{"denouncement_id": denouncementID})
}

func (denouncementController *DenouncementController) UpdateDenouncement(ctx *gin.Context) {
	var denouncement Denouncement
	if err := ctx.ShouldBindJSON(&denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	updatedDenouncement, err := denouncementController.Gateway.Update(denouncement)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"denouncement_id": updatedDenouncement.ID})
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
	ctx.JSON(http.StatusOK, gin.H{"denouncement": denouncement})
}

func (denouncementController *DenouncementController) GetAllDenouncements(ctx *gin.Context) {
	denouncements, err := denouncementController.Gateway.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"denouncements": denouncements})
}

func (denouncementController *DenouncementController) CreateComment(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	var commentDetails CommentDetails
	if err := ctx.ShouldBindJSON(&commentDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	createdComment, err := denouncementController.Gateway.CreateComment(denouncementID, commentDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"comment_id": createdComment.ID})
}

func (denouncementController *DenouncementController) DeleteComment(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	idx := CommentIdentifiersDTO{DenouncementID: denouncementID, CommentID: commentID}
	validate := validator.New()
	if err := validate.Struct(idx); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := denouncementController.Gateway.DeleteComment(idx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Comment deleted successfully"})
}

func (denouncementController *DenouncementController) CreateCommentResponse(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	var responseDetails ResponseDetails
	if err := ctx.ShouldBindJSON(&responseDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(responseDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	idx := CommentIdentifiersDTO{
		DenouncementID: denouncementID,
		CommentID:      commentID,
	}
	if err := validate.Struct(idx); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	createdResponse, err := denouncementController.Gateway.CreateResponse(
		idx,
		responseDetails,
	)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"comment_response_id": createdResponse.ID})
}

func (denouncementController *DenouncementController) DeleteCommentResponse(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	responseID := ctx.Param("response_id")
	idx := ResponseIdentifiersDTO{
		DenouncementID: denouncementID,
		CommentID:      commentID,
		ResponseID:     responseID,
	}
	validate := validator.New()
	if err := validate.Struct(idx); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := denouncementController.Gateway.DeleteResponse(idx); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Comment response deleted successfully"})
}

func (denouncementController *DenouncementController) CreateCommentReaction(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	var reactionDetails CommentReactionDetails
	if err := ctx.ShouldBindJSON(&reactionDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(reactionDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	idx := CommentIdentifiersDTO{
		DenouncementID: denouncementID,
		CommentID:      commentID,
	}
	if err := validate.Struct(idx); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	createdReaction, err := denouncementController.Gateway.CreateCommentReaction(
		idx,
		reactionDetails,
	)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"comment_reaction": createdReaction})
}

func (denouncementController *DenouncementController) DeleteCommentReaction(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	authorID := ctx.Param("author_id")
	idx := CommentReactionIdentifiersDTO{
		DenouncementID: denouncementID,
		CommentID:      commentID,
		AuthorID:       authorID,
	}
	validate := validator.New()
	if err := validate.Struct(idx); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := denouncementController.Gateway.DeleteCommentReaction(idx); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Comment reaction deleted successfully"})
}

func (denouncementController *DenouncementController) CreateCommentResponseReaction(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	responseID := ctx.Param("response_id")
	var reactionDetails ResponseReactionDetails
	if err := ctx.ShouldBindJSON(&reactionDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	idx := ResponseIdentifiersDTO{
		DenouncementID: denouncementID,
		CommentID:      commentID,
		ResponseID:     responseID,
	}
	validate := validator.New()
	if err := validate.Struct(idx); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	createdReaction, err := denouncementController.Gateway.CreateResponseReaction(
		idx,
		reactionDetails,
	)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"response_reaction": createdReaction})
}

func (denouncementController *DenouncementController) DeleteCommentResponseReaction(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	commentID := ctx.Param("comment_id")
	responseID := ctx.Param("response_id")
	authorID := ctx.Param("author_id")
	idx := ResponseReactionIdentifiersDTO{
		DenouncementID: denouncementID,
		CommentID:      commentID,
		ResponseID:     responseID,
		AuthorID:       authorID,
	}
	validate := validator.New()
	if err := validate.Struct(idx); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := denouncementController.Gateway.DeleteResponseReaction(idx); err != nil {
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
