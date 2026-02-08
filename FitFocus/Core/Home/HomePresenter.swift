import SwiftUI

@Observable
@MainActor
class HomePresenter {
    
    private let interactor: HomeInteractor
    private let router: HomeRouter
    
    var sessions: [BJJSessionModel] {
        interactor.bjjSessions
    }
    
    init(interactor: HomeInteractor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func onViewAppear(delegate: HomeDelegate) {
        interactor.trackScreenEvent(event: Event.onAppear(delegate: delegate))
    }
    
    func onViewDisappear(delegate: HomeDelegate) {
        interactor.trackEvent(event: Event.onDisappear(delegate: delegate))
    }
    
    func handleDeepLink(url: URL) {
        interactor.trackEvent(event: Event.deepLinkStart)

        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems,
            !queryItems.isEmpty else {
            interactor.trackEvent(event: Event.deepLinkNoQueryItems)
            return
        }
        
        interactor.trackEvent(event: Event.deepLinkSuccess)
        
        for queryItem in queryItems {
            if let value = queryItem.value, !value.isEmpty {
                // Do something with value
            }
        }
    }
    
    func handlePushNotificationRecieved(notification: Notification) {
        interactor.trackEvent(event: Event.pushNotifStart)
        
        guard
            let userInfo = notification.userInfo,
            !userInfo.isEmpty else {
            interactor.trackEvent(event: Event.pushNotifNoData)
            return
        }
        
        interactor.trackEvent(event: Event.pushNotifSuccess)
        
        for (_, _) in userInfo {
            // Do something with (key, value)
        }
    }
    
    func onDevSettingsPressed() {
        #if MOCK || DEV
        interactor.trackEvent(event: Event.onDevSettings)
        router.showDevSettingsView()
        #else
        interactor.trackEvent(event: Event.onDevSettingsFail)
        #endif
    }
    
    func createSession(session: BJJSessionModel) async {
        interactor.trackEvent(event: Event.createSessionStart)
        do {
            try await interactor.createBJJSession(session: session)
            interactor.trackEvent(event: Event.createSessionSuccess)
        } catch {
            interactor.trackEvent(event: Event.createSessionFail(error: error))
        }
    }
    
    func updateRating(sessionId: String, rating: Int) async {
        interactor.trackEvent(event: Event.updateRatingStart)
        do {
            try await interactor.updateBJJSessionRating(sessionId: sessionId, rating: rating)
            interactor.trackEvent(event: Event.updateRatingSuccess)
        } catch {
            interactor.trackEvent(event: Event.updateRatingFail(error: error))
        }
    }
    
    func deleteSession(sessionId: String) async {
        interactor.trackEvent(event: Event.deleteSessionStart)
        do {
            try await interactor.deleteBJJSession(sessionId: sessionId)
            interactor.trackEvent(event: Event.deleteSessionSuccess)
        } catch {
            interactor.trackEvent(event: Event.deleteSessionFail(error: error))
        }
    }
}

extension HomePresenter {
    
    enum Event: LoggableEvent {
        case onAppear(delegate: HomeDelegate)
        case onDisappear(delegate: HomeDelegate)
        case deepLinkStart
        case deepLinkNoQueryItems
        case deepLinkSuccess
        case pushNotifStart
        case pushNotifNoData
        case pushNotifSuccess
        case onDevSettings
        case onDevSettingsFail
        case createSessionStart
        case createSessionSuccess
        case createSessionFail(error: Error)
        case updateRatingStart
        case updateRatingSuccess
        case updateRatingFail(error: Error)
        case deleteSessionStart
        case deleteSessionSuccess
        case deleteSessionFail(error: Error)

        var eventName: String {
            switch self {
            case .onAppear:                 return "HomeView_Appear"
            case .onDisappear:              return "HomeView_Disappear"
            case .deepLinkStart:            return "HomeView_DeepLink_Start"
            case .deepLinkNoQueryItems:     return "HomeView_DeepLink_NoItems"
            case .deepLinkSuccess:          return "HomeView_DeepLink_Success"
            case .pushNotifStart:           return "HomeView_PushNotif_Start"
            case .pushNotifNoData:          return "HomeView_PushNotif_NoItems"
            case .pushNotifSuccess:         return "HomeView_PushNotif_Success"
            case .onDevSettings:            return "HomeView_DevSettings"
            case .onDevSettingsFail:        return "HomeView_DevSettings_Fail"
            case .createSessionStart:       return "HomeView_CreateSession_Start"
            case .createSessionSuccess:     return "HomeView_CreateSession_Success"
            case .createSessionFail:        return "HomeView_CreateSession_Fail"
            case .updateRatingStart:        return "HomeView_UpdateRating_Start"
            case .updateRatingSuccess:      return "HomeView_UpdateRating_Success"
            case .updateRatingFail:         return "HomeView_UpdateRating_Fail"
            case .deleteSessionStart:       return "HomeView_DeleteSession_Start"
            case .deleteSessionSuccess:     return "HomeView_DeleteSession_Success"
            case .deleteSessionFail:        return "HomeView_DeleteSession_Fail"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .onAppear(delegate: let delegate), .onDisappear(delegate: let delegate):
                return delegate.eventParameters
            case .createSessionFail(error: let error), .updateRatingFail(error: let error), .deleteSessionFail(error: let error):
                return error.eventParameters
            default:
                return nil
            }
        }
        
        var type: LogType {
            switch self {
            case .onDevSettingsFail, .createSessionFail, .updateRatingFail, .deleteSessionFail:
                return .severe
            default:
                return .analytic
            }
        }
    }

}
