//
//  RemoteBJJSessionService.swift
//
//
//

import Foundation

@MainActor
protocol RemoteBJJSessionService: Sendable {
    func getSession(sessionId: String) async throws -> BJJSessionModel
    func getSessions(userId: String) async throws -> [BJJSessionModel]
    func saveSession(session: BJJSessionModel) async throws
    func updateSessionDuration(sessionId: String, duration: TimeInterval) async throws
    func updateSessionRating(sessionId: String, rating: Int) async throws
    func updateSessionNotes(sessionId: String, notes: String) async throws
    func updateSessionType(sessionId: String, sessionType: BJJSessionModel.SessionType) async throws
    func updateSessionTechniques(sessionId: String, techniques: [String]) async throws
    func deleteSession(sessionId: String) async throws
    func streamSessions(userId: String) -> AsyncThrowingStream<[BJJSessionModel], Error>
}
