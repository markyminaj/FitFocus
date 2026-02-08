//
//  CreateSessionView.swift
//
//
//

import SwiftUI
import SwiftfulUI

struct CreateSessionDelegate {
    let onSessionCreated: () -> Void
    
    var eventParameters: [String: Any]? {
        nil
    }
}

struct CreateSessionView: View {
    
    @State var presenter: CreateSessionPresenter
    let delegate: CreateSessionDelegate
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var selectedType: BJJSessionModel.SessionType = .gi
    @State private var durationMinutes: String = ""
    @State private var rating: Int?
    @State private var techniquesText: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Session Details") {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("Type", selection: $selectedType) {
                        Text("Gi").tag(BJJSessionModel.SessionType.gi)
                        Text("No-Gi").tag(BJJSessionModel.SessionType.noGi)
                        Text("Open Mat").tag(BJJSessionModel.SessionType.openMat)
                        Text("Drilling").tag(BJJSessionModel.SessionType.drilling)
                        Text("Competition").tag(BJJSessionModel.SessionType.competition)
                        Text("Private Lesson").tag(BJJSessionModel.SessionType.privateLesson)
                    }
                    
                    TextField("Duration (minutes)", text: $durationMinutes)
                        .keyboardType(.numberPad)
                }
                
                Section("Rating") {
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: rating ?? 0 >= star ? "star.fill" : "star")
                                .foregroundStyle(rating ?? 0 >= star ? .yellow : .gray)
                                .font(.title2)
                                .anyButton(.press) {
                                    rating = star
                                }
                        }
                        
                        if rating != nil {
                            Spacer()
                            Button("Clear") {
                                rating = nil
                            }
                            .font(.caption)
                        }
                    }
                }
                
                Section("Techniques") {
                    TextField("e.g., Armbar, Triangle Choke", text: $techniquesText, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Notes") {
                    TextField("Session notes...", text: $notes, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presenter.onCancelPressed()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSession()
                    }
                    .disabled(presenter.isSaving)
                }
            }
            .disabled(presenter.isSaving)
            .overlay {
                if presenter.isSaving {
                    ProgressView("Saving...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            .alert("Error", isPresented: $presenter.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(presenter.errorMessage)
            }
            .onAppear {
                presenter.onViewAppear(delegate: delegate)
            }
        }
    }
    
    private func saveSession() {
        let duration: TimeInterval? = {
            guard let minutes = Int(durationMinutes), minutes > 0 else { return nil }
            return TimeInterval(minutes * 60)
        }()
        
        let techniques: [String]? = {
            let trimmed = techniquesText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return nil }
            return trimmed.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        }()
        
        let sessionNotes: String? = {
            let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }()
        
        Task {
            let success = await presenter.onSavePressed(
                date: selectedDate,
                sessionType: selectedType,
                duration: duration,
                rating: rating,
                techniques: techniques,
                notes: sessionNotes
            )
            
            if success {
                delegate.onSessionCreated()
                dismiss()
            }
        }
    }
}

#Preview("Standard") {
    let container = DevPreview.shared.container()
    let interactor = CoreInteractor(container: container)
    let builder = CoreBuilder(interactor: interactor)
    let delegate = CreateSessionDelegate(onSessionCreated: {})
    
    return RouterView { router in
        builder.createSessionView(router: router, delegate: delegate)
    }
}

extension CoreBuilder {
    
    func createSessionView(router: AnyRouter, delegate: CreateSessionDelegate) -> some View {
        CreateSessionView(
            presenter: CreateSessionPresenter(
                interactor: interactor,
                router: CoreRouter(router: router, builder: self)
            ),
            delegate: delegate
        )
    }
}

extension CoreRouter {
    
    func showCreateSessionView(delegate: CreateSessionDelegate) {
        router.showScreen(.sheet) { router in
            builder.createSessionView(router: router, delegate: delegate)
        }
    }
}
