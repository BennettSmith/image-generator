
import Foundation

public class AIImage {
    public let id: AIImageId
    public let prompt: String
    public let whenGenerated: Date
    public let content: Data
    
    public init(id: AIImageId, prompt: String, whenGenerated: Date, content: Data) {
        self.id = id
        self.prompt = prompt
        self.whenGenerated = whenGenerated
        self.content = content
    }
}

