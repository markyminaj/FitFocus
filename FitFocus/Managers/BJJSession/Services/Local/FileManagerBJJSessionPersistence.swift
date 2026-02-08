//
//  FileManagerBJJSessionPersistence.swift
//
//
//

import Foundation

@MainActor
struct FileManagerBJJSessionPersistence: LocalBJJSessionPersistence {
    
    private let fileName = "bjj_sessions.json"
    
    private var fileURL: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    func getSessions() -> [BJJSessionModel] {
        guard let fileURL = fileURL,
              FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let sessions = try JSONDecoder().decode([BJJSessionModel].self, from: data)
            return sessions
        } catch {
            print("Error loading sessions from disk: \(error)")
            return []
        }
    }
    
    func saveSessions(sessions: [BJJSessionModel]) throws {
        guard let fileURL = fileURL else {
            throw FileManagerBJJSessionPersistenceError.fileURLNotFound
        }
        
        let data = try JSONEncoder().encode(sessions)
        try data.write(to: fileURL, options: [.atomic])
    }
    
    func clearSessions() throws {
        guard let fileURL = fileURL else {
            throw FileManagerBJJSessionPersistenceError.fileURLNotFound
        }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
    
    enum FileManagerBJJSessionPersistenceError: LocalizedError {
        case fileURLNotFound
        
        var errorDescription: String? {
            switch self {
            case .fileURLNotFound:
                return "Could not find file URL for BJJ sessions storage"
            }
        }
    }
}
