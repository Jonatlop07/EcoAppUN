package user

import (
	"context"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type UserRepository interface {
	GetAll() ([]User, error)
	Create(user *User) error
	GetByID(id string) (*User, error)
	Delete(id string) error
}

type MongoDBUserRepository struct {
	Collection *mongo.Collection
}

func (repository *MongoDBUserRepository) GetAll() ([]User, error) {
	var users []User
	cursor, err := repository.Collection.Find(context.TODO(), bson.M{})
	if err != nil {
		return nil, err
	}
	defer cursor.Close(context.TODO())
	for cursor.Next(context.TODO()) {
		var user User
		if err := cursor.Decode(&user); err != nil {
			return nil, err
		}
		users = append(users, user)
	}
	if err := cursor.Err(); err != nil {
		return nil, err
	}
	return users, nil
}

func (r *MongoDBUserRepository) Create(user *User) error {
	user.ID = primitive.NewObjectID().Hex()
	_, err := r.Collection.InsertOne(context.TODO(), user)
	return err
}

func (r *MongoDBUserRepository) GetByID(id string) (*User, error) {
	var user User
	err := r.Collection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&user)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, ErrUserNotFound
		}
		return nil, err
	}
	return &user, nil
}

func (r *MongoDBUserRepository) Delete(id string) error {
	result, err := r.Collection.DeleteOne(context.TODO(), bson.M{"_id": id})
	if err != nil {
		return err
	}
	if result.DeletedCount == 0 {
		return ErrUserNotFound
	}
	return nil
}

func ProvideUserRepository(database *mongo.Database) UserRepository {
	return &MongoDBUserRepository{
		Collection: database.Collection("users"),
	}
}
