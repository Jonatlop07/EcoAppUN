package sowing

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type SowingWorkshopRepository interface {
	Create(sowingWorkshopDetails SowingWorkshopDetails) (SowingWorkshop, error)
	GetByID(id string) (*SowingWorkshop, error)
	GetAll() ([]SowingWorkshop, error)
	Update(workshop SowingWorkshop) (SowingWorkshop, error)
	Delete(id string) error
	AddAttendee(sowingWorkshopId string, attendee Attendee) (Attendee, error)
	RemoveAttendee(sowingWorkshopId string, attendeeId string) error
	UpdateObjectives(sowingWorkshopId string, objectives []Objective) ([]Objective, error)
}

type MongoDBSowingWorkshopRepository struct {
	SowingWorkshopsCollection *mongo.Collection
}

func (repository *MongoDBSowingWorkshopRepository) Create(sowingWorkshopDetails SowingWorkshopDetails) (SowingWorkshop, error) {
	sowingWorkshop := FromDetails(sowingWorkshopDetails)
	sowingWorkshopModel := FromSowingWorkshop(sowingWorkshop)
	_, err := repository.SowingWorkshopsCollection.InsertOne(context.TODO(), sowingWorkshopModel)
	if err != nil {
		return SowingWorkshop{}, err
	}
	return sowingWorkshop, nil
}

func (repository *MongoDBSowingWorkshopRepository) GetByID(id string) (*SowingWorkshop, error) {
	var workshop SowingWorkshop
	err := repository.SowingWorkshopsCollection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&workshop)
	if err != nil {
		return nil, err
	}
	return &workshop, nil
}

func (repository *MongoDBSowingWorkshopRepository) GetAll() ([]SowingWorkshop, error) {
	var workshops []SowingWorkshop
	cur, err := repository.SowingWorkshopsCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cur.Close(context.TODO())
	if err = cur.All(context.TODO(), &workshops); err != nil {
		return nil, err
	}
	if workshops == nil {
		workshops = []SowingWorkshop{}
	}
	return workshops, nil
}

func (repository *MongoDBSowingWorkshopRepository) Update(workshop SowingWorkshop) (SowingWorkshop, error) {
	workshopModel := FromSowingWorkshop(workshop)
	workshopModel.UpdatedAt = time.Now()
	_, err := repository.SowingWorkshopsCollection.ReplaceOne(context.TODO(), bson.M{"_id": workshop.ID}, workshopModel)
	if err != nil {
		return SowingWorkshop{}, err
	}
	return FromSowingWorkshopModel(workshopModel), nil
}

func (repository *MongoDBSowingWorkshopRepository) Delete(id string) error {
	objID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return err
	}
	_, err = repository.SowingWorkshopsCollection.DeleteOne(context.TODO(), bson.M{"_id": objID})
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBSowingWorkshopRepository) AddAttendee(sowingWorkshopId string, attendee Attendee) (Attendee, error) {
	repository.RemoveAttendee(sowingWorkshopId, attendee.ID)
	seeds, err := repository.getSeeds(sowingWorkshopId)
	if err != nil {
		return Attendee{}, err
	}
	seedsWithAddition := repository.seedsWithAddition(seeds, attendee.Seeds)
	filter := bson.M{"_id": sowingWorkshopId}
	update := bson.M{
		"$set": bson.M{"seeds": seedsWithAddition},
		"$push": bson.M{
			"sowing_workshops.$.attendees": attendee,
		},
	}
	_, err = repository.SowingWorkshopsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return Attendee{}, err
	}
	return attendee, nil
}

func (repository *MongoDBSowingWorkshopRepository) RemoveAttendee(sowingWorkshopId string, attendeeID string) error {
	attendee, err := repository.getAttendeeByID(sowingWorkshopId, attendeeID)
	if err != nil {
		return err
	}
	seeds, err := repository.getSeeds(sowingWorkshopId)
	if err != nil {
		return err
	}
	seedsWithSubstraction := repository.seedsWithSubstraction(seeds, attendee.Seeds)
	filter := bson.M{"_id": sowingWorkshopId}
	update := bson.M{
		"$set": bson.M{"seeds": seedsWithSubstraction},
		"$pull": bson.M{
			"sowing_workshops.$.attendees": attendeeID,
		},
	}
	_, err = repository.SowingWorkshopsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBSowingWorkshopRepository) getAttendeeByID(
	sowingWorkshopID string,
	attendeeID string,
) (*Attendee, error) {
	filter := bson.M{
		"_id":           sowingWorkshopID,
		"attendees._id": attendeeID,
	}
	var result SowingWorkshop
	err := repository.SowingWorkshopsCollection.FindOne(context.TODO(), filter).Decode(&result)
	if err != nil {
		return nil, err
	}
	var attendee *Attendee
	for _, a := range result.Attendees {
		if a.ID == attendeeID {
			attendee = &a
			break
		}
	}
	return attendee, nil
}

func (repository *MongoDBSowingWorkshopRepository) getSeeds(sowingWorkshopID string) ([]Seed, error) {
	filter := bson.M{"_id": sowingWorkshopID}
	opts := options.FindOne().SetProjection(bson.D{{Key: "seeds", Value: 1}})
	var seeds []Seed
	err := repository.SowingWorkshopsCollection.FindOne(context.TODO(), filter, opts).Decode(seeds)
	if err != nil {
		return nil, err
	}
	return seeds, nil
}

func (repository *MongoDBSowingWorkshopRepository) seedsWithAddition(seeds []Seed, seedsToAdd []Seed) []Seed {
	seedQuantity := make(map[string]int)
	for _, seed := range seedsToAdd {
		seedQuantity[seed.ID] = seed.AvailableAmount
	}
	for _, seed := range seeds {
		if amount, ok := seedQuantity[seed.ID]; ok {
			seed.AvailableAmount += amount
		}
	}
	return seeds
}

func (repository *MongoDBSowingWorkshopRepository) seedsWithSubstraction(
	seeds []Seed,
	seedsToSubstract []Seed,
) []Seed {
	seedQuantity := make(map[string]int)
	for _, seed := range seedsToSubstract {
		seedQuantity[seed.ID] = seed.AvailableAmount
	}
	for _, seed := range seeds {
		if amount, ok := seedQuantity[seed.ID]; ok {
			seed.AvailableAmount -= amount
		}
	}
	return seeds
}

func (repository *MongoDBSowingWorkshopRepository) UpdateObjectives(
	sowingWorkshopID string,
	objectives []Objective,
) ([]Objective, error) {
	filter := bson.M{"_id": sowingWorkshopID}
	update := bson.M{"$set": bson.M{"objectives": objectives}}
	opts := options.FindOneAndUpdate().SetReturnDocument(options.After)
	result := repository.SowingWorkshopsCollection.FindOneAndUpdate(context.TODO(), filter, update, opts)
	if result.Err() != nil {
		return nil, result.Err()
	}
	var updatedWorkshop SowingWorkshop
	if err := result.Decode(&updatedWorkshop); err != nil {
		return nil, err
	}

	return updatedWorkshop.Objectives, nil
}

func ProvideSowingWorkshopRepository(database *mongo.Database) SowingWorkshopRepository {
	return &MongoDBSowingWorkshopRepository{
		SowingWorkshopsCollection: database.Collection("sowing_workshops"),
	}
}
