
import Foundation
import Testing
import ImageGeneratorCore

@Test func creatingAIImageSucceeds() throws {
    _ = try AIImage(id: .newAIImageId(), prompt: "Orange cat on a magic carpet.", whenGenerated: .now, content: Data())
}

