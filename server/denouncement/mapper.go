package denouncement

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func FromDetails(denouncementDetails DenouncementDetails) Denouncement {
	denouncementID := primitive.NewObjectID().Hex()
	multimediaElements := []DenouncementMultimedia{}
	for _, multimediaDetails := range denouncementDetails.MultimediaElements {
		multimediaElements = append(
			multimediaElements,
			DenouncementMultimedia{
				Description: multimediaDetails.Description,
				SubmitedAt:  time.Now(),
				Uri:         multimediaDetails.Uri,
			},
		)
	}
	denouncement := Denouncement{
		ID:                 denouncementID,
		DenouncerID:        denouncementDetails.DenouncerID,
		CreatedAt:          time.Now(),
		UpdatedAt:          time.Now(),
		InitialDate:        denouncementDetails.InitialDate,
		FinalDate:          denouncementDetails.FinalDate,
		Title:              denouncementDetails.Title,
		Description:        denouncementDetails.Description,
		MultimediaElements: multimediaElements,
		Comments:           []Comment{},
	}
	return denouncement
}

func FromCommentDetails(commentDetails CommentDetails) Comment {
	commentId := primitive.NewObjectID().Hex()
	responses := []Response{}
	reactions := []CommentReaction{}
	return Comment{
		ID:        commentId,
		AuthorID:  commentDetails.AuthorID,
		Content:   commentDetails.Content,
		CreatedAt: time.Now(),
		Responses: responses,
		Reactions: reactions,
	}
}

func FromResponseDetails(responseDetails ResponseDetails) Response {
	responseId := primitive.NewObjectID().Hex()
	reactions := []ResponseReaction{}
	return Response{
		ID:        responseId,
		AuthorID:  responseDetails.AuthorID,
		Content:   responseDetails.Content,
		CreatedAt: time.Now(),
		Reactions: reactions,
	}
}

func FromCommentReactionDetails(reactionDetails CommentReactionDetails) CommentReaction {
	return CommentReaction{
		AuthorID:  reactionDetails.AuthorID,
		Type:      reactionDetails.Type,
		CreatedAt: time.Now(),
	}
}

func FromResponseReactionDetails(reactionDetails ResponseReactionDetails) ResponseReaction {
	return ResponseReaction{
		AuthorID:  reactionDetails.AuthorID,
		Type:      reactionDetails.Type,
		CreatedAt: time.Now(),
	}
}

func FromDenouncement(denouncement Denouncement) DenouncementModel {
	modelMultimediaElements := []DenouncementMultimediaModel{}
	modelComments := []CommentModel{}
	denouncementId, _ := primitive.ObjectIDFromHex(denouncement.ID)
	denouncerId, _ := primitive.ObjectIDFromHex(denouncement.DenouncerID)
	for _, image := range denouncement.MultimediaElements {
		modelMultimediaElements = append(modelMultimediaElements, FromMultimediaElement(image))
	}
	for _, comment := range denouncement.Comments {
		modelComments = append(modelComments, FromComment(comment))
	}
	return DenouncementModel{
		ID:                 denouncementId,
		DenouncerID:        denouncerId,
		CreatedAt:          denouncement.CreatedAt,
		UpdatedAt:          denouncement.UpdatedAt,
		InitialDate:        denouncement.InitialDate,
		FinalDate:          denouncement.FinalDate,
		Title:              denouncement.Title,
		Description:        denouncement.Description,
		MultimediaElements: modelMultimediaElements,
		Comments:           modelComments,
	}
}

func FromMultimediaElement(multimedia DenouncementMultimedia) DenouncementMultimediaModel {
	var submitedAt time.Time
	if submitedAt = multimedia.SubmitedAt; multimedia.SubmitedAt.IsZero() {
		submitedAt = time.Now()
	}
	return DenouncementMultimediaModel{
		Description: multimedia.Description,
		SubmitedAt:  submitedAt,
		Uri:         multimedia.Uri,
	}
}

func FromComment(comment Comment) CommentModel {
	modelResponses := []ResponseModel{}
	modelReactions := []CommentReactionModel{}
	authorId, _ := primitive.ObjectIDFromHex(comment.AuthorID)
	var commentId primitive.ObjectID
	if comment.ID != "" {
		commentId, _ = primitive.ObjectIDFromHex(comment.ID)
	} else {
		commentId = primitive.NewObjectID()
	}
	for _, response := range comment.Responses {
		modelResponses = append(modelResponses, FromResponse(response))
	}
	for _, reaction := range comment.Reactions {
		modelReactions = append(modelReactions, FromCommentReaction(reaction))
	}
	return CommentModel{
		ID:        commentId,
		AuthorID:  authorId,
		Content:   comment.Content,
		CreatedAt: comment.CreatedAt,
		Responses: modelResponses,
		Reactions: modelReactions,
	}
}

func FromCommentReaction(reaction CommentReaction) CommentReactionModel {
	authorId, _ := primitive.ObjectIDFromHex(reaction.AuthorID)
	return CommentReactionModel{
		Type:      reaction.Type,
		AuthorID:  authorId,
		CreatedAt: reaction.CreatedAt,
	}
}

func FromResponse(response Response) ResponseModel {
	modelReactions := []ResponseReactionModel{}
	authorId, _ := primitive.ObjectIDFromHex(response.AuthorID)
	var responseId primitive.ObjectID
	if response.ID != "" {
		responseId, _ = primitive.ObjectIDFromHex(response.ID)
	} else {
		responseId = primitive.NewObjectID()
	}
	for _, reaction := range response.Reactions {
		modelReactions = append(modelReactions, FromResponseReaction(reaction))
	}
	return ResponseModel{
		ID:        responseId,
		AuthorID:  authorId,
		Content:   response.Content,
		CreatedAt: response.CreatedAt,
		Reactions: modelReactions,
	}
}

func FromResponseReaction(reaction ResponseReaction) ResponseReactionModel {
	authorId, _ := primitive.ObjectIDFromHex(reaction.AuthorID)
	return ResponseReactionModel{
		Type:      reaction.Type,
		AuthorID:  authorId,
		CreatedAt: reaction.CreatedAt,
	}
}

func FromDenouncementModel(model DenouncementModel) Denouncement {
	multimediaElements := []DenouncementMultimedia{}
	comments := []Comment{}
	denouncementId := model.ID.Hex()
	denouncerId := model.DenouncerID.Hex()
	for _, imageModel := range model.MultimediaElements {
		multimediaElements = append(multimediaElements, FromMultimediaElementModel(imageModel))
	}
	for _, comment := range model.Comments {
		comments = append(comments, FromCommentModel(comment))
	}
	return Denouncement{
		ID:                 denouncementId,
		DenouncerID:        denouncerId,
		CreatedAt:          model.CreatedAt,
		UpdatedAt:          model.UpdatedAt,
		InitialDate:        model.InitialDate,
		FinalDate:          model.FinalDate,
		Title:              model.Title,
		Description:        model.Description,
		MultimediaElements: multimediaElements,
		Comments:           comments,
	}
}

func FromMultimediaElementModel(multimediaModel DenouncementMultimediaModel) DenouncementMultimedia {
	return DenouncementMultimedia{
		Description: multimediaModel.Description,
		SubmitedAt:  multimediaModel.SubmitedAt,
		Uri:         multimediaModel.Uri,
	}
}

func FromCommentModel(comment CommentModel) Comment {
	responses := []Response{}
	reactions := []CommentReaction{}
	for _, response := range comment.Responses {
		responses = append(responses, FromResponseModel(response))
	}
	for _, reaction := range comment.Reactions {
		reactions = append(reactions, FromCommentReactionModel(reaction))
	}
	return Comment{
		ID:        comment.ID.Hex(),
		AuthorID:  comment.AuthorID.Hex(),
		Content:   comment.Content,
		CreatedAt: comment.CreatedAt,
		Responses: responses,
		Reactions: reactions,
	}
}

func FromCommentReactionModel(reaction CommentReactionModel) CommentReaction {
	authorId := reaction.AuthorID.Hex()
	return CommentReaction{
		Type:      reaction.Type,
		AuthorID:  authorId,
		CreatedAt: reaction.CreatedAt,
	}
}

func FromResponseModel(response ResponseModel) Response {
	reactions := []ResponseReaction{}
	for _, reaction := range response.Reactions {
		reactions = append(reactions, FromResponseReactionModel(reaction))
	}
	return Response{
		ID:        response.ID.Hex(),
		AuthorID:  response.AuthorID.Hex(),
		Content:   response.Content,
		CreatedAt: response.CreatedAt,
		Reactions: reactions,
	}
}

func FromResponseReactionModel(reaction ResponseReactionModel) ResponseReaction {
	return ResponseReaction{
		Type:      reaction.Type,
		AuthorID:  reaction.AuthorID.Hex(),
		CreatedAt: reaction.CreatedAt,
	}
}
