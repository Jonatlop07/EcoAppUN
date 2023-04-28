package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/google/wire"
	"go.mongodb.org/mongo-driver/mongo"
)

type AppDependencies struct {
	Database       *mongo.Database
	UserController *UserController
}

func provideUserController(database *mongo.Database) *UserController {
	return &UserController{
		Collection: database.Collection("users"),
	}
}

func InitializeAppDependencies() (*AppDependencies, error) {
	wire.Build(
		setupDatabase,
		provideUserController,
		wire.Struct(new(AppDependencies), "*"),
	)
	return &AppDependencies{}, nil
}

func setupRouter(appDependencies *AppDependencies) *gin.Engine {
	userController := appDependencies.UserController
	router := gin.Default()
	router.GET("/users", userController.GetUsers)
	router.POST("/users", userController.CreateUser)
	router.GET("/users/:id", userController.GetUserByID)
	router.DELETE("/users/:id", userController.DeleteUser)
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
