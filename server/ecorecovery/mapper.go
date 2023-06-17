package ecorecovery

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func FromDetails(ecorecoveryWorkshopDetails EcorecoveryWorkshopDetails) EcorecoveryWorkshop {
	ecorecoveryWokshopID := primitive.NewObjectID().Hex()
	objectives := []Objective{}
	for _, objective := range ecorecoveryWorkshopDetails.Objectives {
		objectives = append(objectives, Objective{
			Description: objective,
			IsAchieved:  false,
		})
	}
	ecorecoveryWorkshop := EcorecoveryWorkshop{
		ID:           ecorecoveryWokshopID,
		AuthorID:     ecorecoveryWorkshopDetails.AuthorID,
		Title:        ecorecoveryWorkshopDetails.Title,
		Date:         ecorecoveryWorkshopDetails.Date,
		StartTime:    ecorecoveryWorkshopDetails.StartTime,
		EndTime:      ecorecoveryWorkshopDetails.EndTime,
		Description:  ecorecoveryWorkshopDetails.Description,
		MeetupPoint:  ecorecoveryWorkshopDetails.MeetupPoint,
		Instructions: ecorecoveryWorkshopDetails.Instructions,
		Objectives:   objectives,
		Organizers:   ecorecoveryWorkshopDetails.Organizers,
		Attendees:    []string{},
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}
	return ecorecoveryWorkshop
}

func FromEcorecoveryWorkshop(ecorecoveryWorkshop EcorecoveryWorkshop) EcorecoveryWorkshopModel {
	ecorecoveryWorkshopID, _ := primitive.ObjectIDFromHex(ecorecoveryWorkshop.ID)
	authorID, _ := primitive.ObjectIDFromHex(ecorecoveryWorkshop.AuthorID)
	modelOrganizers := []primitive.ObjectID{}
	modelAttendees := []primitive.ObjectID{}
	for _, organizer := range ecorecoveryWorkshop.Organizers {
		organizerID, _ := primitive.ObjectIDFromHex(organizer)
		modelOrganizers = append(modelOrganizers, organizerID)
	}
	for _, attendee := range ecorecoveryWorkshop.Attendees {
		attendeeId, _ := primitive.ObjectIDFromHex(attendee)
		modelAttendees = append(modelAttendees, attendeeId)
	}
	return EcorecoveryWorkshopModel{
		ID:           ecorecoveryWorkshopID,
		AuthorID:     authorID,
		Title:        ecorecoveryWorkshop.Title,
		CreatedAt:    ecorecoveryWorkshop.CreatedAt,
		UpdatedAt:    ecorecoveryWorkshop.UpdatedAt,
		Date:         ecorecoveryWorkshop.Date,
		StartTime:    ecorecoveryWorkshop.StartTime,
		EndTime:      ecorecoveryWorkshop.EndTime,
		MeetupPoint:  ecorecoveryWorkshop.MeetupPoint,
		Description:  ecorecoveryWorkshop.Description,
		Organizers:   modelOrganizers,
		Attendees:    modelAttendees,
		Instructions: ecorecoveryWorkshop.Instructions,
		Objectives:   ecorecoveryWorkshop.Objectives,
	}
}

func FromEcorecoveryWorkshopModel(ecorecoveryWorkshopModel EcorecoveryWorkshopModel) EcorecoveryWorkshop {
	ecorecoveryWorkshopID := ecorecoveryWorkshopModel.ID.Hex()
	authorID := ecorecoveryWorkshopModel.AuthorID.Hex()
	organizers := []string{}
	attendees := []string{}
	for _, organizerID := range ecorecoveryWorkshopModel.Organizers {
		organizers = append(organizers, organizerID.Hex())
	}
	for _, attendeeID := range ecorecoveryWorkshopModel.Attendees {
		attendees = append(attendees, attendeeID.Hex())
	}
	return EcorecoveryWorkshop{
		ID:           ecorecoveryWorkshopID,
		AuthorID:     authorID,
		Title:        ecorecoveryWorkshopModel.Title,
		CreatedAt:    ecorecoveryWorkshopModel.CreatedAt,
		UpdatedAt:    ecorecoveryWorkshopModel.UpdatedAt,
		Date:         ecorecoveryWorkshopModel.Date,
		StartTime:    ecorecoveryWorkshopModel.StartTime,
		EndTime:      ecorecoveryWorkshopModel.EndTime,
		MeetupPoint:  ecorecoveryWorkshopModel.MeetupPoint,
		Description:  ecorecoveryWorkshopModel.Description,
		Organizers:   organizers,
		Attendees:    attendees,
		Instructions: ecorecoveryWorkshopModel.Instructions,
		Objectives:   ecorecoveryWorkshopModel.Objectives,
	}
}
