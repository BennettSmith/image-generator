import Foundation
import Testing
import SwiftDotenv

@testable import OpenAIClient

private func apikey() throws -> String {
    let home = ProcessInfo.processInfo.environment["HOME"] ?? ""
    try Dotenv.configure(atPath: "\(home)/.env", overwrite: false)
    if let key = Dotenv["OPENAI_API_KEY"] {
        return key.stringValue
    }
    throw "Missing OPENAI_API_KEY environment variable"
}

@Test func apiKeyPresent() async throws {
    let key = try apikey()
    #expect(key.isEmpty == false)
}

@Test func initializeClient() async throws {
    let key = try apikey()
    let _ = OpenAIClient(apiKey: key)
}

@Test func generateImage() async throws {
    let key = try apikey()
    let client = OpenAIClient(apiKey: key)
    await #expect(throws: Never.self, "Should receive an image URL") {
        try await client.generateImage(prompt: "Two cats sleeping in the backseat of a car.")
    }
}
