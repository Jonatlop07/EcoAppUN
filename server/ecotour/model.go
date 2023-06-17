package ecotour

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type EcotourModel struct {
	ID          primitive.ObjectID   `bson:"_id" validate:"required"`
	AuthorID    primitive.ObjectID   `bson:"authorId" validate:"required"`
	Title       string               `bson:"title" validate:"required"`
	CreatedAt   time.Time            `bson:"createdAt" validate:"required"`
	UpdatedAt   time.Time            `bson:"updatedAt" validate:"required"`
	Date        time.Time            `bson:"date" validate:"required"`
	StartTime   time.Time            `bson:"startTime" validate:"required"`
	EndTime     time.Time            `bson:"endTime" validate:"required"`
	MeetupPoint string               `bson:"meetupPoint" validate:"required"`
	Description string               `bson:"description" validate:"required"`
	Organizers  []primitive.ObjectID `bson:"organizers" validate:"required"`
	Attendees   []primitive.ObjectID `bson:"attendees" validate:"required"`
}
