package main

import (
	"eco-app/rest-service/blog"
	"eco-app/rest-service/catalog"
	"eco-app/rest-service/db"
	"eco-app/rest-service/denouncement"
	"eco-app/rest-service/ecorecovery"
	"eco-app/rest-service/ecotour"
	"eco-app/rest-service/sowing"
	"eco-app/rest-service/user"
	"fmt"
	"log"
	"os"

	"github.com/gin-gonic/gin"
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
	BlogController                *blog.BlogController
}

func InitializeAppDependencies() (*AppDependencies, error) {
	db, err := db.SetupDatabase()
	if err != nil {
		return nil, err
	}
	return &AppDependencies{
		Database:                      db,
		UserController:                user.ProvideUserController(user.ProvideUserRepository(db)),
		DenouncementController:        denouncement.ProvideDenouncementController(denouncement.ProvideDenouncementRepository(db)),
		EcotourController:             ecotour.ProvideEcotourController(ecotour.ProvideEcotourRepository(db)),
		SowingWorkshopController:      sowing.ProvideSowingController(sowing.ProvideSowingWorkshopRepository(db)),
		EcorecoveryWorkshopController: ecorecovery.ProvideEcorecoveryWorkshopController(ecorecovery.ProvideEcorecoveryWorkshopRepository(db)),
		CatalogController:             catalog.ProvideCatalogController(catalog.ProvideCatalogRepository(db)),
		BlogController:                blog.ProvideBlogController(blog.ProvideBlogRepository(db)),
	}, nil
}

func setupCORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Credentials", "true")
		c.Header(
			"Access-Control-Allow-Headers",
			"Content-Type, Content-Length, Accept-Encoding,X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With",
		)
		c.Header("Access-Control-Allow-Methods", "POST,HEAD,PATCH, OPTIONS, GET, PUT")
		c.Next()
	}
}

func setupRouter(appDependencies *AppDependencies) *gin.Engine {
	router := gin.Default()
	router.Use(setupCORSMiddleware())
	user.SetupUserRoutes(router, appDependencies.UserController)
	denouncement.SetupDenouncementRoutes(router, appDependencies.DenouncementController)
	ecotour.SetupEcotourRoutes(router, appDependencies.EcotourController)
	sowing.SetupSowingWorkshopRoutes(router, appDependencies.SowingWorkshopController)
	ecorecovery.SetupEcorecoveryWorkshopRoutes(router, appDependencies.EcorecoveryWorkshopController)
	catalog.SetupCatalogRoutes(router, appDependencies.CatalogController)
	blog.SetupBlogRoutes(router, appDependencies.BlogController)
	return router
}

func main() {
	appDependencies, err := InitializeAppDependencies()
	if err != nil {
		log.Fatal(err)
	}
	router := setupRouter(appDependencies)
	host := os.Getenv("API_HOST")
	port := os.Getenv("API_PORT")
	uri := fmt.Sprintf("%s:%s", host, port)
	if err := router.Run(uri); err != nil {
		log.Fatal(err)
	}
}
