package main

import (
	"eco-app/rest-service/db"
	"eco-app/rest-service/users"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/google/wire"
	"go.mongodb.org/mongo-driver/mongo"
)

type AppDependencies struct {
	Database       *mongo.Database
	UserController *users.UserController
}

func provideUserController(database *mongo.Database) *users.UserController {
	return &users.UserController{
		Collection: database.Collection("users"),
	}
}

func InitializeAppDependencies() (*AppDependencies, error) {
	wire.Build(
		db.SetupDatabase,
		provideUserController,
		wire.Struct(new(AppDependencies), "*"),
	)
	return &AppDependencies{}, nil
}

func setupRouter(appDependencies *AppDependencies) *gin.Engine {
	userController := appDependencies.UserController
	router := gin.Default()
	users.SetupUserRoutes(router, userController)
	return router
}

func main() {
	appDependencies, err := InitializeAppDependencies()
	if err != nil {
		log.Fatal(err)
	}
	router := setupRouter(appDependencies)
	if err := router.Run(":8080"); err != nil {
		log.Fatal(err)
	}
}
