package main

import (
	"eco-app/rest-service/db"
	"eco-app/rest-service/denouncements"
	"eco-app/rest-service/users"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/google/wire"
	"go.mongodb.org/mongo-driver/mongo"
)

type AppDependencies struct {
	Database               *mongo.Database
	UserController         *users.UserController
	DenouncementController *denouncements.DenouncementController
}

func InitializeAppDependencies() (*AppDependencies, error) {
	wire.Build(
		db.SetupDatabase,
		users.ProvideUserRepository,
		users.ProvideUserController,
		denouncements.ProvideDenouncementRepository,
		denouncements.ProvideDenouncementController,
		wire.Struct(new(AppDependencies), "*"),
	)
	return &AppDependencies{}, nil
}

func setupRouter(appDependencies *AppDependencies) *gin.Engine {
	userController := appDependencies.UserController
	denouncementController := appDependencies.DenouncementController
	router := gin.Default()
	users.SetupUserRoutes(router, userController)
	denouncements.SetupDenouncementsRoutes(router, denouncementController)
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
