import SwiftUI

@MainActor
protocol HomeInteractor: GlobalInteractor {
    var bjjSessions: [BJJSessionModel] { get }
    func createBJJSession(session: BJJSessionModel) async throws
    func updateBJJSessionRating(sessionId: String, rating: Int) async throws
    func deleteBJJSession(sessionId: String) async throws
}

extension CoreInteractor: HomeInteractor { }
