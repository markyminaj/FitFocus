# BJJSessionManager VIPER Integration Guide

## Overview
The `BJJSessionManager` has been fully integrated into the VIPER architecture following the project's established patterns.

## Architecture Flow

### 1. **Manager Layer** (`BJJSessionManager`)
- Manages BJJ session data with `@Observable` for SwiftUI
- Handles real-time streaming from Firebase
- Syncs remote and local data automatically
- Tracks all analytics events

### 2. **Interactor Layer** (`CoreInteractor`)
- Resolves `BJJSessionManager` from dependency container
- Exposes business logic methods to Presenter
- Starts/stops session streaming on login/logout
- Added to `HomeInteractor` protocol for Home screen access

### 3. **Presenter Layer** (`HomePresenter`)
- Exposes `sessions` property (from interactor)
- Provides action methods: `createSession()`, `updateRating()`, `deleteSession()`
- Tracks analytics for all user actions
- Handles errors and logs failures

### 4. **View Layer** (`HomeView`)
- Displays sessions from `presenter.sessions`
- Swipe-to-delete functionality
- Automatically updates when sessions change (via `@Observable`)

## Key Features

### Real-time Sync
- Sessions automatically stream from Firebase when user logs in
- `@Observable` manager ensures SwiftUI updates automatically
- Local persistence provides offline support

### VIPER Data Flow
```
View → Presenter → Interactor → Manager → Remote/Local Services
```

### Analytics Tracking
Every action is tracked:
- View appearances
- Session creation/updates/deletions
- Success and failure events
- Error details

### Lifecycle Management
- **Login**: Automatically starts listening to user's sessions
- **Logout**: Stops streaming and clears listener
- **Delete Account**: Clean teardown of all data

## Usage Example

### Creating a Session
```swift
// In HomeView
Button("Add Session") {
    Task {
        let session = BJJSessionModel(
            userId: currentUserId,
            sessionType: .gi,
            rating: 5
        )
        await presenter.createSession(session: session)
    }
}
```

### Updating a Rating
```swift
// In HomeView
Button("Rate 5 Stars") {
    Task {
        await presenter.updateRating(sessionId: session.sessionId, rating: 5)
    }
}
```

### Deleting a Session
```swift
// In HomeView (already implemented with swipe actions)
.swipeActions {
    Button(role: .destructive) {
        Task {
            await presenter.deleteSession(sessionId: session.sessionId)
        }
    } label: {
        Label("Delete", systemImage: "trash")
    }
}
```

## Files Modified

### Core Integration
- ✅ `Dependencies.swift` - Registered manager in all build configs
- ✅ `CoreInteractor.swift` - Added manager + BJJ session methods
- ✅ `HomeInteractor.swift` - Added protocol methods for Home screen

### Home Screen Integration
- ✅ `HomePresenter.swift` - Exposed sessions + action methods
- ✅ `HomeView.swift` - Display sessions with swipe-to-delete

### New Manager Files (in `Managers/BJJSession/`)
- ✅ `BJJSessionManager.swift` - Main manager class
- ✅ `RemoteBJJSessionService.swift` - Protocol for remote ops
- ✅ `LocalBJJSessionPersistence.swift` - Protocol for local ops
- ✅ `BJJSessionServices.swift` - Service container
- ✅ `FirebaseBJJSessionService.swift` - Firebase implementation
- ✅ `FileManagerBJJSessionPersistence.swift` - Local file storage
- ✅ `MockBJJSessionService.swift` - Mock remote service
- ✅ `MockBJJSessionPersistence.swift` - Mock local storage

## Next Steps

You can now:
1. ✅ View sessions in HomeView (automatically synced)
2. ✅ Delete sessions (swipe left)
3. 🔨 Add UI to create new sessions
4. 🔨 Add UI to update session details
5. 🔨 Add filtering/sorting capabilities
6. 🔨 Add detail view for individual sessions

## Testing

Mock data is available in all preview environments:
- `BJJSessionModel.mocks` - 4 sample sessions
- `MockBJJSessionServices` - Returns mock data
- Preview in HomeView already configured

## Firebase Setup

The manager uses Firestore collection: `bjj_sessions`

Ensure your Firebase security rules allow:
```javascript
match /bjj_sessions/{sessionId} {
  allow read, write: if request.auth != null && request.auth.uid == resource.data.user_id;
}
```
