package denouncement

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type DenouncementRepository interface {
	Create(denouncementDetails DenouncementDetails) (string, error)
	CreateComment(denouncementId string, commentDetails CommentDetails) (Comment, error)
	CreateResponse(ids CommentIdentifiersDTO, responseDetails ResponseDetails) (Response, error)
	CreateCommentReaction(
		ids CommentIdentifiersDTO,
		reactionDetails CommentReactionDetails,
	) (CommentReaction, error)
	CreateResponseReaction(
		ids ResponseIdentifiersDTO,
		reactionDetails ResponseReactionDetails,
	) (ResponseReaction, error)
	GetByID(id string) (*Denouncement, error)
	GetAll() ([]Denouncement, error)
	Update(denouncement Denouncement) error
	Delete(denouncementId string) error
	DeleteComment(ids CommentIdentifiersDTO) error
	DeleteResponse(ids ResponseIdentifiersDTO) error
	DeleteCommentReaction(ids CommentReactionIdentifiersDTO) error
	DeleteResponseReaction(ids ResponseReactionIdentifiersDTO) error
}

type MongoDBDenouncementRepository struct {
	DenouncementsCollection *mongo.Collection
}

func (r *MongoDBDenouncementRepository) Create(denouncementDetails DenouncementDetails) (string, error) {
	denouncement := FromDetails(denouncementDetails)
	denouncementModel := FromDenouncement(denouncement)
	result, err := r.DenouncementsCollection.InsertOne(context.TODO(), denouncementModel)
	if err != nil {
		return "", err
	}
	return result.InsertedID.(primitive.ObjectID).Hex(), nil
}

func (r *MongoDBDenouncementRepository) Update(denouncement Denouncement) error {
	denouncementModel := FromDenouncement(denouncement)
	denouncementModel.UpdatedAt = time.Now()
	_, err := r.DenouncementsCollection.ReplaceOne(context.TODO(), bson.M{"_id": denouncementModel.ID}, denouncementModel)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) Delete(id string) error {
	modelId, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return err
	}
	_, err = r.DenouncementsCollection.DeleteOne(context.TODO(), bson.M{"_id": modelId})
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) GetByID(id string) (*Denouncement, error) {
	var denouncementModel DenouncementModel
	modelId, _ := primitive.ObjectIDFromHex(id)
	err := r.DenouncementsCollection.FindOne(context.TODO(), bson.M{"_id": modelId}).Decode(&denouncementModel)
	if err != nil {
		return nil, err
	}
	denouncement := FromDenouncementModel(denouncementModel)
	return &denouncement, nil
}

func (r *MongoDBDenouncementRepository) GetAll() ([]Denouncement, error) {
	cur, err := r.DenouncementsCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cur.Close(context.TODO())
	var denouncements []Denouncement
	if err = cur.All(context.TODO(), &denouncements); err != nil {
		return nil, err
	}
	if denouncements == nil {
		denouncements = []Denouncement{}
	}
	return denouncements, nil
}

func (r *MongoDBDenouncementRepository) CreateComment(denouncementId string, commentDetails CommentDetails) (Comment, error) {
	comment := FromCommentDetails(commentDetails)
	commentModel := FromComment(comment)
	filter := bson.M{"_id": denouncementId}
	update := bson.M{
		"$push": bson.M{"comments": commentModel},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return Comment{}, err
	}
	return comment, nil
}

func (r *MongoDBDenouncementRepository) DeleteComment(ids CommentIdentifiersDTO) error {
	filter := bson.M{"_id": ids.DenouncementID}
	update := bson.M{
		"$pull": bson.M{"comments": bson.M{"_id": ids.DenouncementID}},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) CreateResponse(ids CommentIdentifiersDTO, responseDetails ResponseDetails) (Response, error) {
	response := FromResponseDetails(responseDetails)
	responseModel := FromResponse(response)
	filter := bson.M{"_id": ids.DenouncementID, "comments._id": ids.CommentID}
	update := bson.M{
		"$push": bson.M{
			"comments.$.responses": responseModel,
		},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return Response{}, err
	}
	return response, nil
}

func (r *MongoDBDenouncementRepository) DeleteResponse(ids ResponseIdentifiersDTO) error {
	filter := bson.M{"_id": ids.DenouncementID, "comments._id": ids.CommentID}
	update := bson.M{
		"$pull": bson.M{"comments.$.responses": bson.M{"_id": ids.ResponseID}},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) CreateCommentReaction(
	ids CommentIdentifiersDTO,
	reactionDetails CommentReactionDetails,
) (CommentReaction, error) {
	reaction := FromCommentReactionDetails(reactionDetails)
	reactionModel := FromCommentReaction(reaction)
	r.DeleteCommentReaction(
		CommentReactionIdentifiersDTO{
			DenouncementID: ids.DenouncementID,
			CommentID:      ids.CommentID,
			AuthorID:       reaction.AuthorID,
		},
	)
	reaction.CreatedAt = time.Now()
	filter := bson.M{"_id": ids.DenouncementID, "comments._id": ids.CommentID}
	update := bson.M{
		"$push": bson.M{
			"comments.$.reactions": reactionModel,
		},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return CommentReaction{}, err
	}
	return reaction, nil
}

func (r *MongoDBDenouncementRepository) DeleteCommentReaction(ids CommentReactionIdentifiersDTO) error {
	filter := bson.M{"_id": ids.DenouncementID, "comments._id": ids.CommentID}
	update := bson.M{
		"$pull": bson.M{
			"comments.$.responses.$.reactions": bson.M{"authorId": ids.AuthorID},
		},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) CreateResponseReaction(
	ids ResponseIdentifiersDTO,
	reactionDetails ResponseReactionDetails,
) (ResponseReaction, error) {
	reaction := FromResponseReactionDetails(reactionDetails)
	reactionModel := FromResponseReaction(reaction)
	r.DeleteResponseReaction(
		ResponseReactionIdentifiersDTO{
			DenouncementID: ids.DenouncementID,
			CommentID:      ids.CommentID,
			ResponseID:     ids.ResponseID,
			AuthorID:       reaction.AuthorID,
		},
	)
	reaction.CreatedAt = time.Now()
	filter := bson.M{
		"_id":                    ids.DenouncementID,
		"comments._id":           ids.CommentID,
		"comments.responses._id": ids.ResponseID,
	}
	update := bson.M{
		"$push": bson.M{
			"comments.$.responses.$.reactions": reactionModel,
		},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return ResponseReaction{}, err
	}
	return reaction, nil
}

func (r *MongoDBDenouncementRepository) DeleteResponseReaction(ids ResponseReactionIdentifiersDTO) error {
	filter := bson.M{
		"_id":                    ids.DenouncementID,
		"comments._id":           ids.CommentID,
		"comments.responses._id": ids.ResponseID,
	}
	update := bson.M{
		"$pull": bson.M{
			"comments.$.responses.$.reactions": bson.M{"authorId": ids.AuthorID},
		},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func ProvideDenouncementRepository(database *mongo.Database) DenouncementRepository {
	return &MongoDBDenouncementRepository{
		DenouncementsCollection: database.Collection("denouncements"),
	}
}
