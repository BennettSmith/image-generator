
import Foundation
import Testing
import ImageGeneratorCore

@Test func creatingAIImageSucceeds() throws {
    _ = try GeneratedImage(id: .newAIImageId(), prompt: "Orange cat on a magic carpet.", whenGenerated: .now, content: Data())
}

