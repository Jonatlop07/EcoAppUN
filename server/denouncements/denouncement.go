package denouncement

import "time"

type Denouncement struct {
	ID          string    `bson:"_id" json:"id"`
	DenouncerID string    `bson:"denouncerId" json:"denouncer_id"`
	Title       string    `bson:"title" json:"title"`
	CreatedAt   time.Time `bson:"createdAt" json:"created_at"`
	UpdatedAt   time.Time `bson:"updatedAt" json:"updated_at"`
	InitialDate time.Time `bson:"initialDate" json:"initial_date"`
	FinalDate   time.Time `bson:"finalDate" json:"final_date"`
	Description string    `bson:"description" json:"description"`
	MediaLinks  []string  `bson:"mediaLinks" json:"media_links"`
	Comments    []Comment `bson:"comments" json:"comments"`
}
