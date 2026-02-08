//
//  MockBJJSessionPersistence.swift
//
//
//

import Foundation

@MainActor
struct MockBJJSessionPersistence: LocalBJJSessionPersistence {
    
    private var sessions: [BJJSessionModel]
    
    init(sessions: [BJJSessionModel] = BJJSessionModel.mocks) {
        self.sessions = sessions
    }
    
    func getSessions() -> [BJJSessionModel] {
        return sessions
    }
    
    func saveSessions(sessions: [BJJSessionModel]) throws {
        // Mock implementation - would normally persist to disk
    }
    
    func clearSessions() throws {
        // Mock implementation
    }
}
