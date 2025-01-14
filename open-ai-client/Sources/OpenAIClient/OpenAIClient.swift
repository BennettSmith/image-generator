// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import HTTPTypes

public final class OpenAIClient: Sendable {
    let client: Client
    
    public init(apiKey: String) {
        self.client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthMiddleware(apiKey: apiKey)]
        )
    }
    
    public func generateImage(prompt: String) async throws -> URL {
        let response = try await client.createImage(.init(body: .json( .init(prompt: prompt, n: 1, responseFormat: .url, size: ._1024x1024))))
        switch response {
        case .ok(let response):
            switch response.body {
            case .json(let imageResponse) where imageResponse.data.first?.url != nil:
                return URL(string: imageResponse.data[0].url!)!
            default:
                throw "Unknown response"
            }
        default:
            throw "Failed to generate image"
        }
    }
}

struct AuthMiddleware: ClientMiddleware {
    let apiKey: String
    
    func intercept(_ request: HTTPTypes.HTTPRequest, body: OpenAPIRuntime.HTTPBody?, baseURL: URL, operationID: String, next: @Sendable (HTTPTypes.HTTPRequest, OpenAPIRuntime.HTTPBody?, URL) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        var request = request
        request.headerFields.append(.init(name: .authorization, value: "Bearer \(apiKey)"))
        return try await next(request, body, baseURL)
    }
}

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? {
        self
    }
}
