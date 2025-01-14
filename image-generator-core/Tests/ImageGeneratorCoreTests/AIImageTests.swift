import Foundation
import Testing
@testable import AIImage

@Test func creatingAIImageSucceeds() throws {
    _ = try AIImage(id: .newAIImageId(), prompt: "Orange cat on a magic carpet.", whenGenerated: .now, content: Data())
}

