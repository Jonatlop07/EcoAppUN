package main

import (
	"eco-app/rest-service/catalog"
	"eco-app/rest-service/db"
	"eco-app/rest-service/denouncement"
	"eco-app/rest-service/ecorecovery"
	"eco-app/rest-service/ecotour"
	"eco-app/rest-service/sowing"
	"eco-app/rest-service/user"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/google/wire"
	"go.mongodb.org/mongo-driver/mongo"
)

type AppDependencies struct {
	Database                      *mongo.Database
	UserController                *user.UserController
	DenouncementController        *denouncement.DenouncementController
	EcotourController             *ecotour.EcotourController
	SowingWorkshopController      *sowing.SowingWorkshopController
	EcorecoveryWorkshopController *ecorecovery.EcorecoveryWorkshopController
	CatalogController             *catalog.CatalogController
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
		sowing.ProvideSowingWorkshopRepository,
		sowing.ProvideSowingController,
		ecorecovery.ProvideEcorecoveryWorkshopRepository,
		ecorecovery.ProvideEcorecoveryWorkshopController,
		catalog.ProvideCatalogRepository,
		catalog.ProvideCatalogController,
		wire.Struct(new(AppDependencies), "*"),
	)
	return &AppDependencies{}, nil
}

func setupRouter(appDependencies *AppDependencies) *gin.Engine {
	userController := appDependencies.UserController
	denouncementController := appDependencies.DenouncementController
	ecotourController := appDependencies.EcotourController
	sowingWorkshopController := appDependencies.SowingWorkshopController
	ecorecoveryWorkshopController := appDependencies.EcorecoveryWorkshopController
	catalogController := appDependencies.CatalogController
	router := gin.Default()
	user.SetupUserRoutes(router, userController)
	denouncement.SetupDenouncementRoutes(router, denouncementController)
	ecotour.SetupEcotourRoutes(router, ecotourController)
	sowing.SetupSowingWorkshopRoutes(router, sowingWorkshopController)
	ecorecovery.SetupEcorecoveryWorkshopRoutes(router, ecorecoveryWorkshopController)
	catalog.SetupCatalogRoutes(router, catalogController)
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
