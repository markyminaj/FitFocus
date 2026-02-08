//
//  FirebaseBJJSessionService.swift
//
//
//

import Foundation
import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseBJJSessionService: RemoteBJJSessionService {
    
    var collection: CollectionReference {
        Firestore.firestore().collection("bjj_sessions")
    }
    
    func getSession(sessionId: String) async throws -> BJJSessionModel {
        try await collection.getDocument(id: sessionId)
    }
    
    func getSessions(userId: String) async throws -> [BJJSessionModel] {
        try await collection
            .whereField(BJJSessionModel.CodingKeys.userId.rawValue, isEqualTo: userId)
            .order(by: BJJSessionModel.CodingKeys.date.rawValue, descending: true)
            .getAllDocuments()
    }
    
    func saveSession(session: BJJSessionModel) async throws {
        try collection.document(session.sessionId).setData(from: session, merge: true)
    }
    
    func updateSessionDuration(sessionId: String, duration: TimeInterval) async throws {
        try await collection.updateDocument(id: sessionId, dict: [
            BJJSessionModel.CodingKeys.duration.rawValue: duration,
            BJJSessionModel.CodingKeys.updatedAt.rawValue: Date()
        ])
    }
    
    func updateSessionRating(sessionId: String, rating: Int) async throws {
        try await collection.updateDocument(id: sessionId, dict: [
            BJJSessionModel.CodingKeys.rating.rawValue: rating,
            BJJSessionModel.CodingKeys.updatedAt.rawValue: Date()
        ])
    }
    
    func updateSessionNotes(sessionId: String, notes: String) async throws {
        try await collection.updateDocument(id: sessionId, dict: [
            BJJSessionModel.CodingKeys.notes.rawValue: notes,
            BJJSessionModel.CodingKeys.updatedAt.rawValue: Date()
        ])
    }
    
    func updateSessionType(sessionId: String, sessionType: BJJSessionModel.SessionType) async throws {
        try await collection.updateDocument(id: sessionId, dict: [
            BJJSessionModel.CodingKeys.sessionType.rawValue: sessionType.rawValue,
            BJJSessionModel.CodingKeys.updatedAt.rawValue: Date()
        ])
    }
    
    func updateSessionTechniques(sessionId: String, techniques: [String]) async throws {
        try await collection.updateDocument(id: sessionId, dict: [
            BJJSessionModel.CodingKeys.techniques.rawValue: techniques,
            BJJSessionModel.CodingKeys.updatedAt.rawValue: Date()
        ])
    }
    
    func deleteSession(sessionId: String) async throws {
        try await collection.document(sessionId).delete()
    }
    
    func streamSessions(userId: String) -> AsyncThrowingStream<[BJJSessionModel], Error> {
        collection.streamDocument(id: userId)
    }
}
