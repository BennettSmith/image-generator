
import Foundation

public class GeneratedImage {
    public let id: GeneratedImageId
    public let prompt: String
    public let whenGenerated: Date
    public let content: Data
    
    public init(id: GeneratedImageId, prompt: String, whenGenerated: Date, content: Data) {
        self.id = id
        self.prompt = prompt
        self.whenGenerated = whenGenerated
        self.content = content
    }
}

