//
//  BJJSessionModel.swift
//
//
//

import Foundation
import IdentifiableByString

struct BJJSessionModel: StringIdentifiable, Codable, Sendable {
    var id: String {
        sessionId
    }
    
    let sessionId: String
    let userId: String
    let date: Date
    let duration: TimeInterval?
    let sessionType: SessionType?
    let techniques: [String]?
    let notes: String?
    let rating: Int?
    let partnerIds: [String]?
    let createdAt: Date?
    let updatedAt: Date?
    
    init(
        sessionId: String = UUID().uuidString,
        userId: String,
        date: Date = Date(),
        duration: TimeInterval? = nil,
        sessionType: SessionType? = nil,
        techniques: [String]? = nil,
        notes: String? = nil,
        rating: Int? = nil,
        partnerIds: [String]? = nil,
        createdAt: Date? = Date(),
        updatedAt: Date? = nil
    ) {
        self.sessionId = sessionId
        self.userId = userId
        self.date = date
        self.duration = duration
        self.sessionType = sessionType
        self.techniques = techniques
        self.notes = notes
        self.rating = rating
        self.partnerIds = partnerIds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum SessionType: String, Codable, Sendable {
        case noGi = "no_gi"
        case gi = "with_gi"
        case openMat = "open_mat"
        case drilling
        case competition
        case privateLesson = "private_lesson"
    }
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case userId = "user_id"
        case date
        case duration
        case sessionType = "session_type"
        case techniques
        case notes
        case rating
        case partnerIds = "partner_ids"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "session_\(CodingKeys.sessionId.rawValue)": sessionId,
            "session_\(CodingKeys.userId.rawValue)": userId,
            "session_\(CodingKeys.date.rawValue)": date,
            "session_\(CodingKeys.duration.rawValue)": duration,
            "session_\(CodingKeys.sessionType.rawValue)": sessionType?.rawValue,
            "session_\(CodingKeys.techniques.rawValue)_count": techniques?.count,
            "session_has_\(CodingKeys.notes.rawValue)": (notes?.count ?? 0) > 0,
            "session_\(CodingKeys.rating.rawValue)": rating,
            "session_\(CodingKeys.partnerIds.rawValue)_count": partnerIds?.count,
            "session_\(CodingKeys.createdAt.rawValue)": createdAt,
            "session_\(CodingKeys.updatedAt.rawValue)": updatedAt
        ]
        return dict.compactMapValues({ $0 })
    }
    
    var durationInMinutes: Int? {
        guard let duration else { return nil }
        return Int(duration / 60)
    }
    
    var isRated: Bool {
        rating != nil
    }
    
    var hasNotes: Bool {
        guard let notes, !notes.isEmpty else { return false }
        return true
    }
    
    static var mock: Self {
        mocks[0]
    }
    
    static var mocks: [Self] {
        let now = Date()
        return [
            BJJSessionModel(
                sessionId: "session1",
                userId: "user1",
                date: now,
                duration: 3600,
                sessionType: .gi,
                techniques: ["Armbar", "Triangle Choke"],
                notes: "Great session, worked on guard passing",
                rating: 5,
                partnerIds: ["partner1", "partner2"],
                createdAt: now
            ),
            BJJSessionModel(
                sessionId: "session2",
                userId: "user1",
                date: now.addingTimeInterval(-86400),
                duration: 5400,
                sessionType: .noGi,
                techniques: ["Leg locks", "Back takes"],
                rating: 4,
                createdAt: now.addingTimeInterval(-86400)
            ),
            BJJSessionModel(
                sessionId: "session3",
                userId: "user1",
                date: now.addingTimeInterval(-172800),
                duration: 7200,
                sessionType: .openMat,
                notes: "Focused on drilling submissions",
                createdAt: now.addingTimeInterval(-172800)
            ),
            BJJSessionModel(
                sessionId: "session4",
                userId: "user2",
                date: now.addingTimeInterval(-259200),
                duration: 3600,
                sessionType: .competition,
                techniques: ["Takedowns", "Guard retention"],
                rating: 5,
                createdAt: now.addingTimeInterval(-259200)
            )
        ]
    }
}
