package sowing

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type SowingWorkshopModel struct {
	ID           primitive.ObjectID   `bson:"_id" json:"id"`
	AuthorID     primitive.ObjectID   `bson:"authorId" json:"author_id"`
	Title        string               `bson:"title" json:"title"`
	CreatedAt    time.Time            `bson:"createdAt" json:"created_at"`
	UpdatedAt    time.Time            `bson:"updatedAt" json:"updated_at"`
	StartTime    time.Time            `bson:"startTime" json:"start_time"`
	EndTime      time.Time            `bson:"endTime" json:"end_time"`
	MeetupPoint  string               `bson:"meetupPoint" json:"meetup_point"`
	Description  string               `bson:"description" json:"description"`
	Organizers   []primitive.ObjectID `bson:"organizers" json:"organizers"`
	Attendees    []AttendeeModel      `bson:"attendees" json:"attendees"`
	Instructions []string             `bson:"instructions" json:"instructions"`
	Seeds        []SeedModel          `bson:"seeds" json:"seeds"`
	Objectives   []Objective          `bson:"objectives" json:"objectives"`
}

type AttendeeModel struct {
	ID    primitive.ObjectID `bson:"_id" json:"id"`
	Seeds []SeedModel        `bson:"seeds" json:"seeds"`
}

type SeedModel struct {
	ID              primitive.ObjectID `bson:"_id" json:"id"`
	Description     string             `bson:"description" json:"description"`
	ImageLink       string             `bson:"imageLink" json:"image_link"`
	AvailableAmount int                `bson:"availableAmount" json:"available_amount"`
}
