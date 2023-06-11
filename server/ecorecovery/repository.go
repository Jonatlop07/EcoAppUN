package ecorecovery

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type EcorecoveryWorkshopRepository interface {
	Create(workshopDetails EcorecoveryWorkshopDetails) (string, error)
	GetByID(id string) (*EcorecoveryWorkshop, error)
	GetAll() ([]EcorecoveryWorkshop, error)
	Update(workshop EcorecoveryWorkshop) error
	Delete(id string) error
	AddAttendee(workshopID string, attendeeID string) error
	RemoveAttendee(workshopID string, attendeeID string) error
	UpdateObjectives(workshopID string, objectives []Objective) ([]Objective, error)
}

type MongoDBEcorecoveryWorkshopRepository struct {
	EcorecoveryWorkshopsCollection *mongo.Collection
}

func (repository *MongoDBEcorecoveryWorkshopRepository) Create(workshopDetails EcorecoveryWorkshopDetails) (string, error) {
	workshop := FromDetails(workshopDetails)
	workshopModel := FromEcorecoveryWorkshop(workshop)
	result, err := repository.EcorecoveryWorkshopsCollection.InsertOne(context.TODO(), workshopModel)
	if err != nil {
		return "", err
	}
	return result.InsertedID.(primitive.ObjectID).Hex(), nil
}

func (repository *MongoDBEcorecoveryWorkshopRepository) GetByID(id string) (*EcorecoveryWorkshop, error) {
	var workshop EcorecoveryWorkshop
	err := repository.EcorecoveryWorkshopsCollection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&workshop)
	if err != nil {
		return nil, err
	}
	return &workshop, nil
}

func (repository *MongoDBEcorecoveryWorkshopRepository) GetAll() ([]EcorecoveryWorkshop, error) {
	var workshops []EcorecoveryWorkshop
	cur, err := repository.EcorecoveryWorkshopsCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cur.Close(context.TODO())
	if err = cur.All(context.TODO(), &workshops); err != nil {
		return nil, err
	}
	if workshops == nil {
		workshops = []EcorecoveryWorkshop{}
	}
	return workshops, nil
}

func (repository *MongoDBEcorecoveryWorkshopRepository) Update(workshop EcorecoveryWorkshop) error {
	workshopModel := FromEcorecoveryWorkshop(workshop)
	workshopModel.UpdatedAt = time.Now()
	_, err := repository.EcorecoveryWorkshopsCollection.UpdateOne(context.TODO(), bson.M{"_id": workshopModel.ID}, workshopModel)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBEcorecoveryWorkshopRepository) Delete(id string) error {
	objID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return err
	}
	_, err = repository.EcorecoveryWorkshopsCollection.DeleteOne(context.TODO(), bson.M{"_id": objID})
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBEcorecoveryWorkshopRepository) AddAttendee(workshopID string, attendeeID string) error {
	repository.RemoveAttendee(workshopID, attendeeID)
	filter := bson.M{"_id": workshopID}
	update := bson.M{
		"$push": bson.M{
			"ecorecovery_workshops.$.attendees": attendeeID,
		},
	}
	_, err := repository.EcorecoveryWorkshopsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBEcorecoveryWorkshopRepository) RemoveAttendee(workshopID string, attendeeID string) error {
	filter := bson.M{"_id": workshopID}
	update := bson.M{
		"$pull": bson.M{
			"ecorecovery_workshops.$.attendees": attendeeID,
		},
	}
	_, err := repository.EcorecoveryWorkshopsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBEcorecoveryWorkshopRepository) UpdateObjectives(recoveryWorkshopID string, objectives []Objective) ([]Objective, error) {
	filter := bson.M{"_id": recoveryWorkshopID}
	update := bson.M{"$set": bson.M{"objectives": objectives}}
	opts := options.FindOneAndUpdate().SetReturnDocument(options.After)
	result := repository.EcorecoveryWorkshopsCollection.FindOneAndUpdate(context.TODO(), filter, update, opts)
	if result.Err() != nil {
		return nil, result.Err()
	}
	var updatedWorkshop EcorecoveryWorkshop
	if err := result.Decode(&updatedWorkshop); err != nil {
		return nil, err
	}
	return updatedWorkshop.Objectives, nil
}

func ProvideEcorecoveryWorkshopRepository(database *mongo.Database) EcorecoveryWorkshopRepository {
	return &MongoDBEcorecoveryWorkshopRepository{
		EcorecoveryWorkshopsCollection: database.Collection("ecorecovery_workshops"),
	}
}
