package sowing

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type SowingWorkshopModel struct {
	ID           primitive.ObjectID   `bson:"_id" validate:"required"`
	AuthorID     primitive.ObjectID   `bson:"authorId" validate:"required"`
	Title        string               `bson:"title" validate:"required"`
	CreatedAt    time.Time            `bson:"createdAt" validate:"required"`
	UpdatedAt    time.Time            `bson:"updatedAt" validate:"required"`
	Date         time.Time            `bson:"date" validate:"required"`
	StartTime    time.Time            `bson:"startTime" validate:"required"`
	EndTime      time.Time            `bson:"endTime" validate:"required"`
	MeetupPoint  string               `bson:"meetupPoint" validate:"required"`
	Description  string               `bson:"description" validate:"required"`
	Organizers   []primitive.ObjectID `bson:"organizers" validate:"required"`
	Attendees    []AttendeeModel      `bson:"attendees" validate:"required"`
	Instructions []string             `bson:"instructions" validate:"required"`
	Seeds        []SeedModel          `bson:"seeds" validate:"required"`
	Objectives   []Objective          `bson:"objectives" validate:"required"`
}

type AttendeeModel struct {
	ID    primitive.ObjectID `bson:"_id" validate:"required"`
	Seeds []SeedModel        `bson:"seeds" validate:"required"`
}

type SeedModel struct {
	ID              primitive.ObjectID `bson:"_id" validate:"required"`
	Description     string             `bson:"description" validate:"required"`
	ImageLink       string             `bson:"imageLink" validate:"required"`
	AvailableAmount int                `bson:"availableAmount" validate:"required"`
}
