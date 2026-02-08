//
//  FitFocusUnitTests.swift
//  FitFocusUnitTests
//
//  
//

import Testing
@testable import FitFocus

@Suite("HomeView Session Display Tests")
struct FitFocusUnitTests {

    @Test("BJJSessionModel has correct duration conversion to minutes")
    func sessionDurationInMinutes() async throws {
        let session = BJJSessionModel(
            userId: "test_user",
            duration: 3600
        )
        
        #expect(session.durationInMinutes == 60, "3600 seconds should convert to 60 minutes")
    }
    
    @Test("BJJSessionModel correctly identifies rated sessions")
    func sessionRatingStatus() async throws {
        let ratedSession = BJJSessionModel(
            userId: "test_user",
            rating: 5
        )
        
        let unratedSession = BJJSessionModel(
            userId: "test_user",
            rating: nil
        )
        
        #expect(ratedSession.isRated, "Session with rating should be marked as rated")
        #expect(!unratedSession.isRated, "Session without rating should not be marked as rated")
    }
    
    @Test("BJJSessionModel correctly identifies sessions with notes")
    func sessionNotesStatus() async throws {
        let sessionWithNotes = BJJSessionModel(
            userId: "test_user",
            notes: "Great training session"
        )
        
        let sessionWithoutNotes = BJJSessionModel(
            userId: "test_user",
            notes: nil
        )
        
        let sessionWithEmptyNotes = BJJSessionModel(
            userId: "test_user",
            notes: ""
        )
        
        #expect(sessionWithNotes.hasNotes, "Session with notes should return true")
        #expect(!sessionWithoutNotes.hasNotes, "Session without notes should return false")
        #expect(!sessionWithEmptyNotes.hasNotes, "Session with empty notes should return false")
    }

}
