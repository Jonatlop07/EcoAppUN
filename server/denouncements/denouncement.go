package denouncement

import "time"

type Denouncement struct {
	ID          string    `json:"id"`
	DenouncerID string    `json:"denouncerId"`
	Title       string    `json:"title"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
	InitialDate time.Time `json:"initialDate"`
	FinalDate   time.Time `json:"finalDate"`
	Description string    `json:"description"`
	MediaLinks  []string  `json:"mediaLinks"`
	Comments    []Comment `json:"comments"`
}
