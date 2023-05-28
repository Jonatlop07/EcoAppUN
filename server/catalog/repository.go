package catalog

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type CatalogRepository interface {
	Create(catalogRecordDetails *CatalogRecordDetails) (string, error)
	GetByID(id string) (*CatalogRecord, error)
	GetAll() ([]*CatalogRecord, error)
	Update(catalogRecord *CatalogRecord) error
	Delete(id string) error
	AddSpeciesImage(imageDetails *Image) error
}

type MongoDBCatalogRepository struct {
	CatalogRecordsCollection *mongo.Collection
}

func (repository *MongoDBCatalogRepository) Create(catalogRecordDetails *CatalogRecordDetails) (string, error) {
	catalogRecord := FromDetails(catalogRecordDetails)
	result, err := repository.CatalogRecordsCollection.InsertOne(context.TODO(), catalogRecord)
	if err != nil {
		return "", err
	}
	return result.InsertedID.(primitive.ObjectID).String(), nil
}

func (repository *MongoDBCatalogRepository) GetByID(id string) (*CatalogRecord, error) {
	var catalogRecord CatalogRecord
	err := repository.CatalogRecordsCollection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&catalogRecord)
	if err != nil {
		return nil, err
	}
	return &catalogRecord, nil
}

func (repository *MongoDBCatalogRepository) GetAll() ([]*CatalogRecord, error) {
	var catalogRecords []*CatalogRecord
	cur, err := repository.CatalogRecordsCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cur.Close(context.TODO())
	for cur.Next(context.TODO()) {
		var record CatalogRecord
		err := cur.Decode(&record)
		if err != nil {
			return nil, err
		}
		catalogRecords = append(catalogRecords, &record)
	}
	return catalogRecords, nil
}

func (repository *MongoDBCatalogRepository) Update(catalogRecord *CatalogRecord) error {
	catalogRecord.UpdatedAt = time.Now()
	images := &catalogRecord.Images
	for _, image := range *images {
		if image.SubmitedAt.IsZero() {
			image.SubmitedAt = time.Now()
		}
	}
	_, err := repository.CatalogRecordsCollection.ReplaceOne(context.TODO(), bson.M{"_id": catalogRecord.ID}, catalogRecord)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBCatalogRepository) Delete(id string) error {
	_, err := repository.CatalogRecordsCollection.DeleteOne(context.TODO(), bson.M{"_id": id})
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBCatalogRepository) AddSpeciesImage(imageDetails *Image) error {
	if imageDetails.SubmitedAt.IsZero() {
		imageDetails.SubmitedAt = time.Now()
	}
	filter := bson.M{"_id": imageDetails.CatalogRecordID}
	update := bson.M{"$push": bson.M{"images": imageDetails}}
	_, err := repository.CatalogRecordsCollection.UpdateOne(context.TODO(), filter, update)
	if err != nil {
		return err
	}
	return nil
}

func ProvideCatalogRepository(database *mongo.Database) CatalogRepository {
	return &MongoDBCatalogRepository{
		CatalogRecordsCollection: database.Collection("catalog_records"),
	}
}
