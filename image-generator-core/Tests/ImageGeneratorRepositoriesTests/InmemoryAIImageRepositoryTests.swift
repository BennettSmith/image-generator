
import Foundation
import Testing
import ImageGeneratorCore
import ImageGeneratorRepositories

@Test func creatingAIImageSucceeds() throws {
    _ = try GeneratedImage(id: .newAIImageId(), prompt: "Orange cat on a magic carpet.", whenGenerated: .now, content: Data())
}

