//
//  BJJSessionServices.swift
//
//
//

import Foundation

@MainActor
protocol BJJSessionServices {
    var remote: RemoteBJJSessionService { get }
    var local: LocalBJJSessionPersistence { get }
}

@MainActor
struct MockBJJSessionServices: BJJSessionServices {
    let remote: RemoteBJJSessionService
    let local: LocalBJJSessionPersistence
    
    init(sessions: [BJJSessionModel] = BJJSessionModel.mocks) {
        self.remote = MockBJJSessionService(sessions: sessions)
        self.local = MockBJJSessionPersistence(sessions: sessions)
    }
}

struct ProductionBJJSessionServices: BJJSessionServices {
    let remote: RemoteBJJSessionService = FirebaseBJJSessionService()
    let local: LocalBJJSessionPersistence = FileManagerBJJSessionPersistence()
}
