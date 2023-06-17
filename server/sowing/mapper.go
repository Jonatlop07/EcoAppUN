package sowing

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func FromDetails(sowingWorkshopDetails SowingWorkshopDetails) SowingWorkshop {
	sowingWokshopID := primitive.NewObjectID().Hex()
	objectives := []Objective{}
	seeds := []Seed{}
	for _, objective := range sowingWorkshopDetails.Objectives {
		objectives = append(objectives, Objective{
			Description: objective,
			IsAchieved:  false,
		})
	}
	for _, seed := range sowingWorkshopDetails.Seeds {
		seeds = append(seeds, Seed{
			ID:              primitive.NewObjectID().Hex(),
			Description:     seed.Description,
			ImageLink:       seed.ImageLink,
			AvailableAmount: seed.AvailableAmount,
		})
	}
	sowingWorkshop := SowingWorkshop{
		ID:           sowingWokshopID,
		AuthorID:     sowingWorkshopDetails.AuthorID,
		Title:        sowingWorkshopDetails.Title,
		Date:         sowingWorkshopDetails.Date,
		StartTime:    sowingWorkshopDetails.StartTime,
		EndTime:      sowingWorkshopDetails.EndTime,
		Description:  sowingWorkshopDetails.Description,
		MeetupPoint:  sowingWorkshopDetails.MeetupPoint,
		Instructions: sowingWorkshopDetails.Instructions,
		Objectives:   objectives,
		Organizers:   sowingWorkshopDetails.Organizers,
		Seeds:        seeds,
		Attendees:    []Attendee{},
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}
	return sowingWorkshop
}

func FromSowingWorkshop(sowingWorkshop SowingWorkshop) SowingWorkshopModel {
	sowingWorkshopID, _ := primitive.ObjectIDFromHex(sowingWorkshop.ID)
	authorID, _ := primitive.ObjectIDFromHex(sowingWorkshop.AuthorID)
	modelOrganizers := []primitive.ObjectID{}
	modelSeeds := []SeedModel{}
	modelAttendees := []AttendeeModel{}
	for _, organizer := range sowingWorkshop.Organizers {
		organizerID, _ := primitive.ObjectIDFromHex(organizer)
		modelOrganizers = append(modelOrganizers, organizerID)
	}
	for _, seed := range sowingWorkshop.Seeds {
		modelSeeds = append(modelSeeds, FromSeed(seed))
	}
	for _, attendee := range sowingWorkshop.Attendees {
		modelAttendees = append(modelAttendees, FromAttendee(attendee))
	}
	return SowingWorkshopModel{
		ID:           sowingWorkshopID,
		AuthorID:     authorID,
		Title:        sowingWorkshop.Title,
		CreatedAt:    sowingWorkshop.CreatedAt,
		UpdatedAt:    sowingWorkshop.UpdatedAt,
		Date:         sowingWorkshop.Date,
		StartTime:    sowingWorkshop.StartTime,
		EndTime:      sowingWorkshop.EndTime,
		MeetupPoint:  sowingWorkshop.MeetupPoint,
		Description:  sowingWorkshop.Description,
		Organizers:   modelOrganizers,
		Attendees:    modelAttendees,
		Instructions: sowingWorkshop.Instructions,
		Objectives:   sowingWorkshop.Objectives,
		Seeds:        modelSeeds,
	}
}

func FromSeed(seed Seed) SeedModel {
	var seedId primitive.ObjectID
	if seed.ID != "" {
		seedId, _ = primitive.ObjectIDFromHex(seed.ID)
	} else {
		seedId = primitive.NewObjectID()
	}
	return SeedModel{
		ID:              seedId,
		Description:     seed.Description,
		ImageLink:       seed.ImageLink,
		AvailableAmount: seed.AvailableAmount,
	}
}

func FromAttendee(attendee Attendee) AttendeeModel {
	attendeeId, _ := primitive.ObjectIDFromHex(attendee.ID)
	modelSeeds := []SeedModel{}
	for _, seed := range attendee.Seeds {
		modelSeeds = append(modelSeeds, FromSeed(seed))
	}
	return AttendeeModel{
		ID:    attendeeId,
		Seeds: modelSeeds,
	}
}

func FromSowingWorkshopModel(sowingWorkshopModel SowingWorkshopModel) SowingWorkshop {
	sowingWorkshopID := sowingWorkshopModel.ID.Hex()
	authorID := sowingWorkshopModel.AuthorID.Hex()
	organizers := []string{}
	seeds := []Seed{}
	attendees := []Attendee{}
	for _, organizerID := range sowingWorkshopModel.Organizers {
		organizers = append(organizers, organizerID.Hex())
	}
	for _, seedModel := range sowingWorkshopModel.Seeds {
		seeds = append(seeds, FromSeedModel(seedModel))
	}
	for _, attendeeModel := range sowingWorkshopModel.Attendees {
		attendees = append(attendees, FromAttendeeModel(attendeeModel))
	}
	return SowingWorkshop{
		ID:           sowingWorkshopID,
		AuthorID:     authorID,
		Title:        sowingWorkshopModel.Title,
		CreatedAt:    sowingWorkshopModel.CreatedAt,
		UpdatedAt:    sowingWorkshopModel.UpdatedAt,
		Date:         sowingWorkshopModel.Date,
		StartTime:    sowingWorkshopModel.StartTime,
		EndTime:      sowingWorkshopModel.EndTime,
		MeetupPoint:  sowingWorkshopModel.MeetupPoint,
		Description:  sowingWorkshopModel.Description,
		Organizers:   organizers,
		Attendees:    attendees,
		Instructions: sowingWorkshopModel.Instructions,
		Objectives:   sowingWorkshopModel.Objectives,
		Seeds:        seeds,
	}
}

func FromSeedModel(seedModel SeedModel) Seed {
	return Seed{
		ID:              seedModel.ID.Hex(),
		Description:     seedModel.Description,
		ImageLink:       seedModel.ImageLink,
		AvailableAmount: seedModel.AvailableAmount,
	}
}

func FromAttendeeModel(attendeeModel AttendeeModel) Attendee {
	seeds := []Seed{}
	for _, seedModel := range attendeeModel.Seeds {
		seeds = append(seeds, FromSeedModel(seedModel))
	}
	return Attendee{
		ID:    attendeeModel.ID.Hex(),
		Seeds: seeds,
	}
}
