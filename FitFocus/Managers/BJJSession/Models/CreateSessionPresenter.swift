//
//  CreateSessionPresenter.swift
//
//
//

import SwiftUI

@Observable
@MainActor
class CreateSessionPresenter {
    
    private let interactor: HomeInteractor
    private let router: HomeRouter
    
    var isSaving = false
    var showError = false
    var errorMessage = ""
    
    init(interactor: HomeInteractor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func onViewAppear(delegate: CreateSessionDelegate) {
        interactor.trackScreenEvent(event: Event.onAppear(delegate: delegate))
    }
    
    func onCancelPressed() {
        interactor.trackEvent(event: Event.onCancel)
    }
    
    func onSavePressed(
        date: Date,
        sessionType: BJJSessionModel.SessionType,
        duration: TimeInterval?,
        rating: Int?,
        techniques: [String]?,
        notes: String?
    ) async -> Bool {
        guard let userId = interactor.currentUser?.userId else {
            errorMessage = "User not found. Please try again."
            showError = true
            interactor.trackEvent(event: Event.saveFail(error: "No user ID"))
            return false
        }
        
        isSaving = true
        interactor.trackEvent(event: Event.saveStart)
        
        let session = BJJSessionModel(
            userId: userId,
            date: date,
            duration: duration,
            sessionType: sessionType,
            techniques: techniques,
            notes: notes,
            rating: rating
        )
        
        do {
            try await interactor.createBJJSession(session: session)
            interactor.trackEvent(event: Event.saveSuccess)
            isSaving = false
            return true
        } catch {
            errorMessage = "Failed to save session. Please try again."
            showError = true
            isSaving = false
            interactor.trackEvent(event: Event.saveFail(error: error.localizedDescription))
            return false
        }
    }
}

extension CreateSessionPresenter {
    
    enum Event: LoggableEvent {
        case onAppear(delegate: CreateSessionDelegate)
        case onCancel
        case saveStart
        case saveSuccess
        case saveFail(error: String)
        
        var eventName: String {
            switch self {
            case .onAppear:     return "CreateSession_Appear"
            case .onCancel:     return "CreateSession_Cancel"
            case .saveStart:    return "CreateSession_Save_Start"
            case .saveSuccess:  return "CreateSession_Save_Success"
            case .saveFail:     return "CreateSession_Save_Fail"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .onAppear(delegate: let delegate):
                return delegate.eventParameters
            case .saveFail(error: let error):
                return ["error": error]
            default:
                return nil
            }
        }
        
        var type: LogType {
            switch self {
            case .saveFail:
                return .severe
            default:
                return .analytic
            }
        }
    }
}
