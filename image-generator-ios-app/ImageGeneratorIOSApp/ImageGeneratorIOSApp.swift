
import SwiftUI

@main
struct ImageGeneratorIOSApp: App {
    let composer: ImageGeneratorFactory = ProductionComposer()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(factory: composer)
            }
        }
    }
}
