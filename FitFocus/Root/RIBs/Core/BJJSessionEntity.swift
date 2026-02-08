//
//  BJJSessionEntity.swift
//
//
//

import Foundation
import SwiftData

@Model
class BJJSessionEntity {
    @Attribute(.unique) var sessionId: String
    var userId: String
    var date: Date
    var duration: TimeInterval?
    var sessionTypeRawValue: String?
    var techniques: [String]?
    var notes: String?
    var rating: Int?
    var partnerIds: [String]?
    var createdAt: Date?
    var updatedAt: Date?
    var dateAdded: Date
    
    init(from model: BJJSessionModel) {
        self.sessionId = model.sessionId
        self.userId = model.userId
        self.date = model.date
        self.duration = model.duration
        self.sessionTypeRawValue = model.sessionType?.rawValue
        self.techniques = model.techniques
        self.notes = model.notes
        self.rating = model.rating
        self.partnerIds = model.partnerIds
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
        self.dateAdded = .now
    }
    
    func toModel() -> BJJSessionModel {
        BJJSessionModel(
            sessionId: sessionId,
            userId: userId,
            date: date,
            duration: duration,
            sessionType: sessionTypeRawValue.flatMap { BJJSessionModel.SessionType(rawValue: $0) },
            techniques: techniques,
            notes: notes,
            rating: rating,
            partnerIds: partnerIds,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
