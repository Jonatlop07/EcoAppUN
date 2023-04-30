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
	Update(*Denouncement) error
	Delete(string) error
	DeleteCommentsByDenouncementID(string) error
	FindByID(string) (*Denouncement, error)
	FindAll() ([]*Denouncement, error)
}

type MongoDBDenouncementRepository struct {
	DenouncementsCollection *mongo.Collection
	CommentsCollection      *mongo.Collection
}

func (r *MongoDBDenouncementRepository) Create(denouncement *Denouncement) error {
	denouncement.ID = primitive.NewObjectID().Hex()
	denouncement.CreatedAt = time.Now()
	denouncement.UpdatedAt = time.Now()
	_, err := r.DenouncementsCollection.InsertOne(context.TODO(), denouncement)
	return err
}

func (r *MongoDBDenouncementRepository) Update(denouncement *Denouncement) error {
	denouncement.UpdatedAt = time.Now()
	_, err := r.DenouncementsCollection.ReplaceOne(context.TODO(), bson.M{"_id": denouncement.ID}, denouncement)
	return err
}

func (r *MongoDBDenouncementRepository) Delete(id string) error {
	_, err := r.DenouncementsCollection.DeleteOne(context.TODO(), bson.M{"_id": id})
	return err
}

func (r *MongoDBDenouncementRepository) DeleteCommentsByDenouncementID(denouncementID string) error {
	filter := bson.M{"denouncementId": denouncementID}
	_, err := r.CommentsCollection.DeleteMany(context.TODO(), filter)
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

func ProvideDenouncementRepository(database *mongo.Database) DenouncementRepository {
	return &MongoDBDenouncementRepository{
		DenouncementsCollection: database.Collection("denouncements"),
		CommentsCollection:      database.Collection("denouncement_comments"),
	}
}
