//
//  MockBJJSessionService.swift
//
//
//

import Foundation

@MainActor
struct MockBJJSessionService: RemoteBJJSessionService {
    
    var sessions: [BJJSessionModel]
    
    init(sessions: [BJJSessionModel] = BJJSessionModel.mocks) {
        self.sessions = sessions
    }
    
    func getSession(sessionId: String) async throws -> BJJSessionModel {
        guard let session = sessions.first(where: { $0.sessionId == sessionId }) else {
            throw MockBJJSessionServiceError.sessionNotFound
        }
        return session
    }
    
    func getSessions(userId: String) async throws -> [BJJSessionModel] {
        return sessions.filter { $0.userId == userId }
    }
    
    func saveSession(session: BJJSessionModel) async throws {
        // Mock implementation - in real app this would save to backend
    }
    
    func updateSessionDuration(sessionId: String, duration: TimeInterval) async throws {
        // Mock implementation
    }
    
    func updateSessionRating(sessionId: String, rating: Int) async throws {
        // Mock implementation
    }
    
    func updateSessionNotes(sessionId: String, notes: String) async throws {
        // Mock implementation
    }
    
    func updateSessionType(sessionId: String, sessionType: BJJSessionModel.SessionType) async throws {
        // Mock implementation
    }
    
    func updateSessionTechniques(sessionId: String, techniques: [String]) async throws {
        // Mock implementation
    }
    
    func deleteSession(sessionId: String) async throws {
        // Mock implementation
    }
    
    func streamSessions(userId: String) -> AsyncThrowingStream<[BJJSessionModel], Error> {
        AsyncThrowingStream { continuation in
            let userSessions = sessions.filter { $0.userId == userId }
            continuation.yield(userSessions)
            continuation.finish()
        }
    }
    
    enum MockBJJSessionServiceError: LocalizedError {
        case sessionNotFound
        
        var errorDescription: String? {
            switch self {
            case .sessionNotFound:
                return "Session not found"
            }
        }
    }
}
