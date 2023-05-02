package users

import "github.com/gin-gonic/gin"

func SetupUserRoutes(router *gin.Engine, userController *UserController) {
	userGroup := router.Group("/users")
	{
		userGroup.GET("", userController.GetUsers)
		userGroup.POST("", userController.CreateUser)
		userGroup.GET("/:id", userController.GetUserByID)
		userGroup.DELETE("/:id", userController.DeleteUser)
	}
}
