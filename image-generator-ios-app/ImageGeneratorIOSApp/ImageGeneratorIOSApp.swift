
import SwiftUI

@main
struct ImageGeneratorIOSApp: App {
    let composer: ImageGeneratorFactory = ProductionComposer(openAiAPIKey: Secrets.openaiApiKey)
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(factory: composer)
            }
        }
    }
}
