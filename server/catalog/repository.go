package catalog

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type CatalogRepository interface {
	Create(catalogRecordDetails CatalogRecordDetails) (string, error)
	GetByID(id string) (*CatalogRecord, error)
	GetAll() ([]CatalogRecord, error)
	Update(catalogRecord CatalogRecord) error
	Delete(id string) error
	AddSpeciesImage(catalogRecordId string, imageDetails Image) error
}

type MongoDBCatalogRepository struct {
	CatalogRecordsCollection *mongo.Collection
}

func (repository *MongoDBCatalogRepository) Create(catalogRecordDetails CatalogRecordDetails) (string, error) {
	catalogRecord := FromDetails(catalogRecordDetails)
	catalogRecordModel := FromCatalogRecord(catalogRecord)
	result, err := repository.CatalogRecordsCollection.InsertOne(context.TODO(), catalogRecordModel)
	if err != nil {
		return "", err
	}
	return result.InsertedID.(primitive.ObjectID).Hex(), nil
}

func (repository *MongoDBCatalogRepository) GetByID(id string) (*CatalogRecord, error) {
	var catalogRecordModel CatalogRecordModel
	modelId, _ := primitive.ObjectIDFromHex(id)
	err := repository.CatalogRecordsCollection.FindOne(context.TODO(), bson.M{"_id": modelId}).Decode(&catalogRecordModel)
	if err != nil {
		return nil, err
	}
	catalogRecord := FromCatalogRecordModel(catalogRecordModel)
	return &catalogRecord, nil
}

func (repository *MongoDBCatalogRepository) GetAll() ([]CatalogRecord, error) {
	var catalogRecords []CatalogRecord
	cur, err := repository.CatalogRecordsCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cur.Close(context.TODO())
	if err = cur.All(context.TODO(), &catalogRecords); err != nil {
		return nil, err
	}
	if catalogRecords == nil {
		catalogRecords = []CatalogRecord{}
	}
	return catalogRecords, nil
}

func (repository *MongoDBCatalogRepository) Update(catalogRecord CatalogRecord) error {
	catalogRecordModel := FromCatalogRecord(catalogRecord)
	catalogRecordModel.UpdatedAt = time.Now()
	_, err := repository.CatalogRecordsCollection.ReplaceOne(context.TODO(), bson.M{"_id": catalogRecordModel.ID}, catalogRecordModel)
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBCatalogRepository) Delete(id string) error {
	modelId, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return err
	}
	_, err = repository.CatalogRecordsCollection.DeleteOne(context.TODO(), bson.M{"_id": modelId})
	if err != nil {
		return err
	}
	return nil
}

func (repository *MongoDBCatalogRepository) AddSpeciesImage(catalogRecordId string, image Image) error {
	catalogRecordModelId, _ := primitive.ObjectIDFromHex(catalogRecordId)
	imageModel := FromImage(image)
	if imageModel.SubmitedAt.IsZero() {
		imageModel.SubmitedAt = time.Now()
	}
	filter := bson.M{"_id": catalogRecordModelId}
	update := bson.M{"$push": bson.M{"images": imageModel}}
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
