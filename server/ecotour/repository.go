package ecotour

import (
	"context"
	"errors"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type EcotourRepository interface {
	Create(ecotourDetails EcotourDetails) (string, error)
	GetByID(id string) (*Ecotour, error)
	GetAll() ([]Ecotour, error)
	Update(ecotour Ecotour) error
	Delete(id string) error
	AddAttendee(ecotourID string, attendeeID string) error
	RemoveAttendee(ecotourID string, attendeeID string) error
}

type MongoDBEcotourRepository struct {
	EcotoursCollection *mongo.Collection
}

func (repository *MongoDBEcotourRepository) Create(ecotourDetails EcotourDetails) (string, error) {
	ecotour := FromDetails(ecotourDetails)
	ecotourModel := FromEcotour(ecotour)
	result, err := repository.EcotoursCollection.InsertOne(context.TODO(), ecotourModel)
	if err != nil {
		return "", err
	}
	return result.InsertedID.(primitive.ObjectID).Hex(), nil
}

func (repository *MongoDBEcotourRepository) GetByID(id string) (*Ecotour, error) {
	var ecotour Ecotour
	err := repository.EcotoursCollection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&ecotour)
	if err != nil {
		if errors.Is(err, mongo.ErrNoDocuments) {
			return nil, err
		}
		return nil, err
	}
	return &ecotour, nil
}

func (repository *MongoDBEcotourRepository) GetAll() ([]Ecotour, error) {
	var ecotours []Ecotour
	cur, err := repository.EcotoursCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cur.Close(context.TODO())
	if err = cur.All(context.TODO(), &ecotours); err != nil {
		return nil, err
	}
	if ecotours == nil {
		ecotours = []Ecotour{}
	}
	return ecotours, nil
}

func (repository *MongoDBEcotourRepository) Update(ecotour Ecotour) error {
	ecotourModel := FromEcotour(ecotour)
	ecotourModel.UpdatedAt = time.Now()
	_, err := repository.EcotoursCollection.ReplaceOne(context.TODO(), bson.M{"_id": ecotourModel.ID}, ecotour)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBEcotourRepository) Delete(id string) error {
	_, err := repository.EcotoursCollection.DeleteOne(context.TODO(), bson.M{"_id": id})
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBEcotourRepository) AddAttendee(ecotourID string, attendeeID string) error {
	repository.RemoveAttendee(ecotourID, attendeeID)
	filter := bson.M{"_id": ecotourID}
	update := bson.M{
		"$push": bson.M{
			"ecotours.$.attendees": attendeeID,
		},
	}
	_, err := repository.EcotoursCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBEcotourRepository) RemoveAttendee(ecotourID string, attendeeID string) error {
	filter := bson.M{"_id": ecotourID}
	update := bson.M{
		"$pull": bson.M{
			"ecotours.$.attendees": attendeeID,
		},
	}
	_, err := repository.EcotoursCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func ProvideEcotourRepository(database *mongo.Database) EcotourRepository {
	return &MongoDBEcotourRepository{
		EcotoursCollection: database.Collection("ecotours"),
	}
}
