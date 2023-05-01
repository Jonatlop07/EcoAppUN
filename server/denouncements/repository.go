package denouncement

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type DenouncementRepository interface {
	Create(*Denouncement) error
	CreateComment(*Comment) error
	CreateResponse(*Response) error
	CreateCommentReaction(*CommentReaction) error
	CreateResponseReaction(*ResponseReaction) error
	FindByID(string) (*Denouncement, error)
	FindAll() ([]*Denouncement, error)
	Update(*Denouncement) error
	Delete(string) error
	DeleteComment(*Comment) error
	DeleteResponse(*Response) error
	DeleteCommentReaction(*CommentReaction) error
	DeleteResponseReaction(*ResponseReaction) error
}

type MongoDBDenouncementRepository struct {
	DenouncementsCollection *mongo.Collection
}

func (r *MongoDBDenouncementRepository) Create(denouncement *Denouncement) error {
	denouncement.ID = primitive.NewObjectID().Hex()
	denouncement.CreatedAt = time.Now()
	denouncement.UpdatedAt = time.Now()
	_, err := r.DenouncementsCollection.InsertOne(context.TODO(), denouncement)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) Update(denouncement *Denouncement) error {
	denouncement.UpdatedAt = time.Now()
	_, err := r.DenouncementsCollection.ReplaceOne(context.TODO(), bson.M{"_id": denouncement.ID}, denouncement)
	if err != nil {
		return err
	}
	return err
}

func (r *MongoDBDenouncementRepository) Delete(id string) error {
	_, err := r.DenouncementsCollection.DeleteOne(context.TODO(), bson.M{"_id": id})
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) FindByID(id string) (*Denouncement, error) {
	var denouncement Denouncement
	err := r.DenouncementsCollection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&denouncement)
	if err != nil {
		return nil, err
	}
	return &denouncement, nil
}

func (r *MongoDBDenouncementRepository) FindAll() ([]*Denouncement, error) {
	var denouncements []*Denouncement
	cur, err := r.DenouncementsCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cur.Close(context.TODO())
	for cur.Next(context.TODO()) {
		var denouncement Denouncement
		err := cur.Decode(&denouncement)
		if err != nil {
			return nil, err
		}
		denouncements = append(denouncements, &denouncement)
	}
	return denouncements, nil
}

func (r *MongoDBDenouncementRepository) CreateComment(comment *Comment) error {
	comment.ID = primitive.NewObjectID().Hex()
	comment.CreatedAt = time.Now()
	filter := bson.M{"_id": comment.DenouncementID}
	update := bson.M{
		"$push": bson.M{"comments": comment},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) DeleteComment(comment *Comment) error {
	filter := bson.M{"_id": comment.DenouncementID}
	update := bson.M{
		"$pull": bson.M{"comments": bson.M{"_id": comment.ID}},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) CreateResponse(response *Response) error {
	response.ID = primitive.NewObjectID().Hex()
	response.CreatedAt = time.Now()
	filter := bson.M{"_id": response.DenouncementID, "comments._id": response.CommentID}
	update := bson.M{
		"$push": bson.M{
			"comments.$.responses": response,
		},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) DeleteResponse(response *Response) error {
	filter := bson.M{"_id": response.DenouncementID, "comments._id": response.CommentID}
	update := bson.M{
		"$pull": bson.M{"comments.$.responses": bson.M{"_id": response.ID}},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) CreateCommentReaction(reaction *CommentReaction) error {
	r.DeleteCommentReaction(reaction)
	filter := bson.M{"_id": reaction.DenouncementID, "comments._id": reaction.CommentID}
	update := bson.M{
		"$push": bson.M{
			"comments.$.reactions": reaction,
		},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) DeleteCommentReaction(reaction *CommentReaction) error {
	filter := bson.M{"_id": reaction.DenouncementID, "comments._id": reaction.CommentID}
	update := bson.M{
		"$pull": bson.M{"comments.$.reactions": bson.M{"_id": reaction.ID}},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) CreateResponseReaction(reaction *ResponseReaction) error {
	r.DeleteResponseReaction(reaction)
	filter := bson.M{
		"_id":                    reaction.DenouncementID,
		"comments._id":           reaction.CommentID,
		"comments.responses._id": reaction.ResponseID,
	}
	update := bson.M{
		"$push": bson.M{
			"comments.$.responses.$.reactions": reaction,
		},
	}
	_, err := r.DenouncementsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (r *MongoDBDenouncementRepository) DeleteResponseReaction(reaction *ResponseReaction) error {
	filter := bson.M{
		"_id":                    reaction.DenouncementID,
		"comments._id":           reaction.CommentID,
		"comments.responses._id": reaction.ResponseID,
	}
	update := bson.M{
		"$pull": bson.M{
			"comments.$.responses.$.reactions": bson.M{"userId": reaction.UserID},
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
