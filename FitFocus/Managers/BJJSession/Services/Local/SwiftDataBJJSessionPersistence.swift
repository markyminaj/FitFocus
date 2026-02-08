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
    
    func getSessions(userId: String) -> [BJJSessionModel] {
        do {
            let predicate = #Predicate<BJJSessionEntity> { entity in
                entity.userId == userId
            }
            let descriptor = FetchDescriptor<BJJSessionEntity>(
                predicate: predicate,
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            let entities = try mainContext.fetch(descriptor)
            return entities.map { $0.toModel() }
        } catch {
            print("Error fetching BJJ sessions for user \(userId) from SwiftData: \(error)")
            return []
        }
    }
    
    func saveSessions(sessions: [BJJSessionModel]) throws {
        // More efficient: Update existing and insert new
        let existingEntities = try fetchAllEntities()
        let existingIds = Set(existingEntities.map { $0.sessionId })
        let newIds = Set(sessions.map { $0.sessionId })
        
        // Delete removed sessions
        let idsToDelete = existingIds.subtracting(newIds)
        for entity in existingEntities where idsToDelete.contains(entity.sessionId) {
            mainContext.delete(entity)
        }
        
        // Update or insert sessions
        for session in sessions {
            if let existingEntity = existingEntities.first(where: { $0.sessionId == session.sessionId }) {
                // Update existing entity
                updateEntity(existingEntity, from: session)
            } else {
                // Insert new entity
                let entity = BJJSessionEntity(from: session)
                mainContext.insert(entity)
            }
        }
        
        try mainContext.save()
    }
    
    func clearSessions() throws {
        let entities = try fetchAllEntities()
        
        for entity in entities {
            mainContext.delete(entity)
        }
        
        try mainContext.save()
    }
    
    func clearSessions(userId: String) throws {
        let predicate = #Predicate<BJJSessionEntity> { entity in
            entity.userId == userId
        }
        let descriptor = FetchDescriptor<BJJSessionEntity>(predicate: predicate)
        let entities = try mainContext.fetch(descriptor)
        
        for entity in entities {
            mainContext.delete(entity)
        }
        
        try mainContext.save()
    }
    
    // MARK: - Private Helpers
    
    private func fetchAllEntities() throws -> [BJJSessionEntity] {
        let descriptor = FetchDescriptor<BJJSessionEntity>()
        return try mainContext.fetch(descriptor)
    }
    
    private func updateEntity(_ entity: BJJSessionEntity, from model: BJJSessionModel) {
        entity.userId = model.userId
        entity.date = model.date
        entity.duration = model.duration
        entity.sessionTypeRawValue = model.sessionType?.rawValue
        entity.techniques = model.techniques
        entity.notes = model.notes
        entity.rating = model.rating
        entity.partnerIds = model.partnerIds
        entity.createdAt = model.createdAt
        entity.updatedAt = model.updatedAt
    }
}
