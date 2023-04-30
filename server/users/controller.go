package users

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

type UserController struct {
	Gateway UserRepository
}

func (userController *UserController) GetUsers(ctx *gin.Context) {
	users, err := userController.Gateway.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, users)
}

func (userController *UserController) CreateUser(ctx *gin.Context) {
	var newUser User
	if err := ctx.ShouldBindJSON(&newUser); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(newUser); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := userController.Gateway.Create(newUser)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusCreated)
}

func (userController *UserController) GetUserByID(ctx *gin.Context) {
	userID := ctx.Param("id")
	user, err := userController.Gateway.GetByID(userID)
	if err != nil {
		if errors.Is(err, ErrUserNotFound) {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}

	ctx.JSON(http.StatusOK, user)
}

func (userController *UserController) DeleteUser(ctx *gin.Context) {
	userID := ctx.Param("id")
	err := userController.Gateway.Delete(userID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func ProvideUserController(userRepository UserRepository) *UserController {
	return &UserController{
		Gateway: userRepository,
	}
}
