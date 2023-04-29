package users

type User struct {
	ID       string `bson:"_id"`
	Username string `bson:"username" json:"username" validate:"required"`
	Password string `bson:"password" json:"password" validate:"required"`
}
