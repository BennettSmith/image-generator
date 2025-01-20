
public protocol UseCase {
    associatedtype Request: Sendable
    associatedtype Response: Sendable
    associatedtype Presenter
    
    func execute(request: Request, presenter: Presenter) async -> Result<Response, Error>
}
