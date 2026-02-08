//
//  SwiftDataBJJSessionPersistence.swift
//
//
//

import Foundation
import SwiftData

@MainActor
struct SwiftDataBJJSessionPersistence: LocalBJJSessionPersistence {
    private let container: ModelContainer
    
    private var mainContext: ModelContext {
        container.mainContext
    }
    
    init() {
        // swiftlint:disable:next force_try
        self.container = try! ModelContainer(for: BJJSessionEntity.self)
    }
    
    func getSessions() -> [BJJSessionModel] {
        do {
            let descriptor = FetchDescriptor<BJJSessionEntity>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            let entities = try mainContext.fetch(descriptor)
            return entities.map { $0.toModel() }
        } catch {
            print("Error fetching BJJ sessions from SwiftData: \(error)")
            return []
        }
    }
    
    func saveSessions(sessions: [BJJSessionModel]) throws {
        // Clear existing sessions
        try clearSessions()
        
        // Insert new sessions
        for session in sessions {
            let entity = BJJSessionEntity(from: session)
            mainContext.insert(entity)
        }
        
        try mainContext.save()
    }
    
    func clearSessions() throws {
        let descriptor = FetchDescriptor<BJJSessionEntity>()
        let entities = try mainContext.fetch(descriptor)
        
        for entity in entities {
            mainContext.delete(entity)
        }
        
        try mainContext.save()
    }
}
