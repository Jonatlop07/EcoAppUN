package ecotour

import (
	"context"
	"errors"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type EcotourRepository interface {
	Create(*Ecotour) error
	GetByID(string) (*Ecotour, error)
	GetAll() ([]*Ecotour, error)
	Update(*Ecotour) error
	Delete(string) error
	AddAttendant(string, string) error
	RemoveAttendant(string, string) error
}

type MongoDBEcotourRepository struct {
	EcotoursCollection *mongo.Collection
}

func (repository *MongoDBEcotourRepository) Create(ecotour *Ecotour) error {
	ecotour.ID = primitive.NewObjectID().Hex()
	_, err := repository.EcotoursCollection.InsertOne(context.TODO(), ecotour)
	if err != nil {
		return err
	}
	return nil
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

func (repository *MongoDBEcotourRepository) GetAll() ([]*Ecotour, error) {
	var ecotours []*Ecotour
	cur, err := repository.EcotoursCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cur.Close(context.TODO())
	for cur.Next(context.TODO()) {
		var ecotour Ecotour
		err := cur.Decode(&ecotour)
		if err != nil {
			return nil, err
		}
		ecotours = append(ecotours, &ecotour)
	}
	return ecotours, nil
}

func (repository *MongoDBEcotourRepository) Update(ecotour *Ecotour) error {
	_, err := repository.EcotoursCollection.ReplaceOne(context.TODO(), bson.M{"_id": ecotour.ID}, ecotour)
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

func (repository *MongoDBEcotourRepository) AddAttendant(ecotourID string, attendantID string) error {
	repository.RemoveAttendant(ecotourID, attendantID)
	filter := bson.M{"_id": ecotourID}
	update := bson.M{
		"$push": bson.M{
			"ecotours.$.attendants": attendantID,
		},
	}
	_, err := repository.EcotoursCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBEcotourRepository) RemoveAttendant(ecotourID string, attendantID string) error {
	filter := bson.M{"_id": ecotourID}
	update := bson.M{
		"$pull": bson.M{
			"ecotours.$.attendants": attendantID,
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
