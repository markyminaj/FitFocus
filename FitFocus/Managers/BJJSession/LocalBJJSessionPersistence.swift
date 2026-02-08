//
//  LocalBJJSessionPersistence.swift
//
//
//

import Foundation

@MainActor
protocol LocalBJJSessionPersistence {
    func getSessions() -> [BJJSessionModel]
    func saveSessions(sessions: [BJJSessionModel]) throws
    func clearSessions() throws
}
