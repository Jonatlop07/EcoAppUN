package ecotour

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func FromDetails(ecotourDetails EcotourDetails) Ecotour {
	ecotourWokshopID := primitive.NewObjectID().Hex()
	ecotour := Ecotour{
		ID:          ecotourWokshopID,
		AuthorID:    ecotourDetails.AuthorID,
		Title:       ecotourDetails.Title,
		Date:        ecotourDetails.Date,
		StartTime:   ecotourDetails.StartTime,
		EndTime:     ecotourDetails.EndTime,
		Description: ecotourDetails.Description,
		MeetupPoint: ecotourDetails.MeetupPoint,
		Organizers:  ecotourDetails.Organizers,
		Attendees:   []string{},
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
	}
	return ecotour
}

func FromEcotour(ecotour Ecotour) EcotourModel {
	ecotourID, _ := primitive.ObjectIDFromHex(ecotour.ID)
	authorID, _ := primitive.ObjectIDFromHex(ecotour.AuthorID)
	modelOrganizers := []primitive.ObjectID{}
	modelAttendees := []primitive.ObjectID{}
	for _, organizer := range ecotour.Organizers {
		organizerID, _ := primitive.ObjectIDFromHex(organizer)
		modelOrganizers = append(modelOrganizers, organizerID)
	}
	for _, attendee := range ecotour.Attendees {
		attendeeId, _ := primitive.ObjectIDFromHex(attendee)
		modelAttendees = append(modelAttendees, attendeeId)
	}
	return EcotourModel{
		ID:          ecotourID,
		AuthorID:    authorID,
		Title:       ecotour.Title,
		CreatedAt:   ecotour.CreatedAt,
		UpdatedAt:   ecotour.UpdatedAt,
		Date:        ecotour.Date,
		StartTime:   ecotour.StartTime,
		EndTime:     ecotour.EndTime,
		MeetupPoint: ecotour.MeetupPoint,
		Description: ecotour.Description,
		Organizers:  modelOrganizers,
		Attendees:   modelAttendees,
	}
}
