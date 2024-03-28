import SwiftUI

@main
struct CardMakerApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(CanvasManager())
        }
    }
}
