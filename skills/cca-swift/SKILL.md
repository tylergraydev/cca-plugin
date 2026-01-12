---
name: cca-swift
description: CCA language context for Swift/iOS/macOS projects. Auto-loaded when Package.swift, *.xcodeproj, or *.swift files are detected.
---

# CCA: Swift Context

## Language Detection
This context applies when any of these files exist:
- `Package.swift` (Swift Package Manager)
- `*.xcodeproj` or `*.xcworkspace`
- `Podfile` (CocoaPods)
- `Cartfile` (Carthage)
- `*.swift` files

## Build-Test-Improve Commands

### Swift Package Manager
```bash
# Build
swift build
swift build -c release

# Test
swift test
swift test --filter TestClassName

# Run
swift run

# Update dependencies
swift package update
```

### Xcode (xcodebuild)
```bash
# Build
xcodebuild -scheme MyApp -configuration Debug build

# Test
xcodebuild -scheme MyApp -destination 'platform=iOS Simulator,name=iPhone 15' test

# Clean
xcodebuild clean

# List schemes
xcodebuild -list
```

### Xcode via xcrun
```bash
# Simulator management
xcrun simctl list devices
xcrun simctl boot "iPhone 15"
xcrun simctl shutdown all
```

### CocoaPods
```bash
pod install
pod update
pod repo update
```

## Common Patterns

### Error Handling
```swift
// Use Result type for async operations
func fetchUser(id: String) async -> Result<User, NetworkError> {
    do {
        let user = try await api.getUser(id: id)
        return .success(user)
    } catch {
        return .failure(.networkError(error))
    }
}

// Custom error types
enum AppError: LocalizedError {
    case networkError(Error)
    case invalidData
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidData:
            return "Invalid data received"
        case .unauthorized:
            return "User is not authorized"
        }
    }
}

// Use throwing functions
func process() throws -> Data {
    guard let data = getData() else {
        throw AppError.invalidData
    }
    return data
}
```

### Optionals & Nil Safety
```swift
// Use guard for early exit
guard let user = currentUser else {
    return
}

// Use if-let for conditional unwrapping
if let name = user.name {
    print("Hello, \(name)")
}

// Nil coalescing
let displayName = user.name ?? "Anonymous"

// Optional chaining
let city = user.address?.city?.name
```

### Concurrency (Swift 5.5+)
```swift
// Async/await
func fetchData() async throws -> [Item] {
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([Item].self, from: data)
}

// Task groups for parallel work
await withTaskGroup(of: Result.self) { group in
    for id in ids {
        group.addTask {
            await fetchItem(id: id)
        }
    }
}

// Actors for thread-safe state
actor DataStore {
    private var cache: [String: Data] = [:]
    
    func getData(for key: String) -> Data? {
        cache[key]
    }
    
    func setData(_ data: Data, for key: String) {
        cache[key] = data
    }
}

// MainActor for UI updates
@MainActor
class ViewModel: ObservableObject {
    @Published var items: [Item] = []
}
```

### SwiftUI Patterns
```swift
// View with state
struct ContentView: View {
    @State private var isLoading = false
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.items) { item in
                ItemRow(item: item)
            }
            .task {
                await viewModel.loadItems()
            }
        }
    }
}

// Environment and dependency injection
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.apiClient, APIClient())
        }
    }
}
```

### UIKit Patterns
```swift
// View controller lifecycle
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        // Configure views
    }
    
    private func bindViewModel() {
        // Set up data binding
    }
}

// Table view delegate/datasource
extension MyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Configure cell
        return cell
    }
}
```

## Project Structure Conventions

### iOS App
```
MyApp/
├── MyApp.xcodeproj/
├── MyApp/
│   ├── App/
│   │   └── MyAppApp.swift       # @main entry
│   ├── Views/
│   │   ├── ContentView.swift
│   │   └── Components/
│   ├── ViewModels/
│   ├── Models/
│   ├── Services/
│   ├── Extensions/
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   └── Localizable.strings
│   └── Info.plist
├── MyAppTests/
└── MyAppUITests/
```

### Swift Package
```
MyPackage/
├── Package.swift
├── Sources/
│   └── MyPackage/
│       └── MyPackage.swift
├── Tests/
│   └── MyPackageTests/
└── README.md
```

## Platform Detection
- `import UIKit` → iOS/tvOS
- `import AppKit` → macOS
- `import WatchKit` → watchOS
- `import SwiftUI` → Cross-platform UI
- `import Vapor` or `import Hummingbird` → Server-side Swift

## Common Gotchas
- `@State` only for value types owned by the view
- `@StateObject` for reference types (create once)
- `@ObservedObject` for reference types (passed in)
- `weak self` in closures to avoid retain cycles
- `Task { }` for async work from sync context
- `@MainActor` for UI updates from background
- Check iOS deployment target in project settings
- `await` suspends but doesn't block the thread
