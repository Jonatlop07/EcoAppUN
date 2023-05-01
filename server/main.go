package main

import (
	"eco-app/rest-service/db"
	denouncement "eco-app/rest-service/denouncements"
	ecotour "eco-app/rest-service/ecotours"
	user "eco-app/rest-service/users"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/google/wire"
	"go.mongodb.org/mongo-driver/mongo"
)

type AppDependencies struct {
	Database               *mongo.Database
	UserController         *user.UserController
	DenouncementController *denouncement.DenouncementController
	EcotourController      *ecotour.EcotourController
}

func InitializeAppDependencies() (*AppDependencies, error) {
	wire.Build(
		db.SetupDatabase,
		user.ProvideUserRepository,
		user.ProvideUserController,
		denouncement.ProvideDenouncementRepository,
		denouncement.ProvideDenouncementController,
		ecotour.ProvideEcotourRepository,
		ecotour.ProvideEcotourController,
		wire.Struct(new(AppDependencies), "*"),
	)
	return &AppDependencies{}, nil
}

func setupRouter(appDependencies *AppDependencies) *gin.Engine {
	userController := appDependencies.UserController
	denouncementController := appDependencies.DenouncementController
	ecotourController := appDependencies.EcotourController
	router := gin.Default()
	user.SetupUserRoutes(router, userController)
	denouncement.SetupDenouncementRoutes(router, denouncementController)
	ecotour.SetupEcotourRoutes(router, ecotourController)
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
