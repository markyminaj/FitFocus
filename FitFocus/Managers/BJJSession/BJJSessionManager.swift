//
//  BJJSessionManager.swift
//
//
//

import SwiftUI

@MainActor
@Observable
class BJJSessionManager {
    
    private let remote: RemoteBJJSessionService
    private let local: LocalBJJSessionPersistence
    private let logManager: LogManager?
    
    private(set) var sessions: [BJJSessionModel] = []
    private var sessionsListenerTask: Task<Void, Error>?
    
    init(services: BJJSessionServices, logManager: LogManager? = nil) {
        self.remote = services.remote
        self.local = services.local
        self.logManager = logManager
        self.sessions = local.getSessions()
    }
    
    func startListening(userId: String) {
        logManager?.trackEvent(event: Event.listenerStart)
        
        sessionsListenerTask?.cancel()
        sessionsListenerTask = Task {
            do {
                for try await sessions in remote.streamSessions(userId: userId) {
                    self.sessions = sessions
                    logManager?.trackEvent(event: Event.listenerSuccess(count: sessions.count))
                    self.saveSessionsLocally()
                }
            } catch {
                logManager?.trackEvent(event: Event.listenerFail(error: error))
            }
        }
    }
    
    func stopListening() {
        logManager?.trackEvent(event: Event.listenerStop)
        sessionsListenerTask?.cancel()
        sessionsListenerTask = nil
    }
    
    private func saveSessionsLocally() {
        logManager?.trackEvent(event: Event.saveLocalStart)
        
        Task {
            do {
                try local.saveSessions(sessions: sessions)
                logManager?.trackEvent(event: Event.saveLocalSuccess)
            } catch {
                logManager?.trackEvent(event: Event.saveLocalFail(error: error))
            }
        }
    }
    
    func createSession(session: BJJSessionModel) async throws {
        logManager?.trackEvent(event: Event.createStart(session: session))
        try await remote.saveSession(session: session)
        logManager?.trackEvent(event: Event.createSuccess(session: session))
    }
    
    func updateSessionDuration(sessionId: String, duration: TimeInterval) async throws {
        logManager?.trackEvent(event: Event.updateDurationStart)
        try await remote.updateSessionDuration(sessionId: sessionId, duration: duration)
        logManager?.trackEvent(event: Event.updateDurationSuccess)
    }
    
    func updateSessionRating(sessionId: String, rating: Int) async throws {
        logManager?.trackEvent(event: Event.updateRatingStart)
        try await remote.updateSessionRating(sessionId: sessionId, rating: rating)
        logManager?.trackEvent(event: Event.updateRatingSuccess)
    }
    
    func updateSessionNotes(sessionId: String, notes: String) async throws {
        logManager?.trackEvent(event: Event.updateNotesStart)
        try await remote.updateSessionNotes(sessionId: sessionId, notes: notes)
        logManager?.trackEvent(event: Event.updateNotesSuccess)
    }
    
    func updateSessionType(sessionId: String, sessionType: BJJSessionModel.SessionType) async throws {
        logManager?.trackEvent(event: Event.updateTypeStart)
        try await remote.updateSessionType(sessionId: sessionId, sessionType: sessionType)
        logManager?.trackEvent(event: Event.updateTypeSuccess)
    }
    
    func updateSessionTechniques(sessionId: String, techniques: [String]) async throws {
        logManager?.trackEvent(event: Event.updateTechniquesStart)
        try await remote.updateSessionTechniques(sessionId: sessionId, techniques: techniques)
        logManager?.trackEvent(event: Event.updateTechniquesSuccess)
    }
    
    func deleteSession(sessionId: String) async throws {
        logManager?.trackEvent(event: Event.deleteStart)
        try await remote.deleteSession(sessionId: sessionId)
        logManager?.trackEvent(event: Event.deleteSuccess)
    }
    
    func getSession(sessionId: String) async throws -> BJJSessionModel {
        try await remote.getSession(sessionId: sessionId)
    }
    
    func getSessions(userId: String) async throws -> [BJJSessionModel] {
        try await remote.getSessions(userId: userId)
    }
    
    func clearLocalSessions() throws {
        logManager?.trackEvent(event: Event.clearLocalStart)
        try local.clearSessions()
        sessions = []
        logManager?.trackEvent(event: Event.clearLocalSuccess)
    }
    
    enum Event: LoggableEvent {
        case listenerStart
        case listenerSuccess(count: Int)
        case listenerFail(error: Error)
        case listenerStop
        case saveLocalStart
        case saveLocalSuccess
        case saveLocalFail(error: Error)
        case createStart(session: BJJSessionModel)
        case createSuccess(session: BJJSessionModel)
        case updateDurationStart
        case updateDurationSuccess
        case updateRatingStart
        case updateRatingSuccess
        case updateNotesStart
        case updateNotesSuccess
        case updateTypeStart
        case updateTypeSuccess
        case updateTechniquesStart
        case updateTechniquesSuccess
        case deleteStart
        case deleteSuccess
        case clearLocalStart
        case clearLocalSuccess
        
        var eventName: String {
            switch self {
            case .listenerStart:            return "BJJSessionMan_Listener_Start"
            case .listenerSuccess:          return "BJJSessionMan_Listener_Success"
            case .listenerFail:             return "BJJSessionMan_Listener_Fail"
            case .listenerStop:             return "BJJSessionMan_Listener_Stop"
            case .saveLocalStart:           return "BJJSessionMan_SaveLocal_Start"
            case .saveLocalSuccess:         return "BJJSessionMan_SaveLocal_Success"
            case .saveLocalFail:            return "BJJSessionMan_SaveLocal_Fail"
            case .createStart:              return "BJJSessionMan_Create_Start"
            case .createSuccess:            return "BJJSessionMan_Create_Success"
            case .updateDurationStart:      return "BJJSessionMan_UpdateDuration_Start"
            case .updateDurationSuccess:    return "BJJSessionMan_UpdateDuration_Success"
            case .updateRatingStart:        return "BJJSessionMan_UpdateRating_Start"
            case .updateRatingSuccess:      return "BJJSessionMan_UpdateRating_Success"
            case .updateNotesStart:         return "BJJSessionMan_UpdateNotes_Start"
            case .updateNotesSuccess:       return "BJJSessionMan_UpdateNotes_Success"
            case .updateTypeStart:          return "BJJSessionMan_UpdateType_Start"
            case .updateTypeSuccess:        return "BJJSessionMan_UpdateType_Success"
            case .updateTechniquesStart:    return "BJJSessionMan_UpdateTechniques_Start"
            case .updateTechniquesSuccess:  return "BJJSessionMan_UpdateTechniques_Success"
            case .deleteStart:              return "BJJSessionMan_Delete_Start"
            case .deleteSuccess:            return "BJJSessionMan_Delete_Success"
            case .clearLocalStart:          return "BJJSessionMan_ClearLocal_Start"
            case .clearLocalSuccess:        return "BJJSessionMan_ClearLocal_Success"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .listenerSuccess(count: let count):
                return ["count": count]
            case .listenerFail(error: let error), .saveLocalFail(error: let error):
                return error.eventParameters
            case .createStart(session: let session), .createSuccess(session: let session):
                return session.eventParameters
            default:
                return nil
            }
        }
        
        var type: LogType {
            switch self {
            case .listenerFail, .saveLocalFail:
                return .severe
            default:
                return .analytic
            }
        }
    }
}
