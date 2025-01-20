
public protocol UseCase {
    associatedtype Request
    associatedtype Response
    associatedtype Presenter
    
    func execute(request: Request, presenter: Presenter) async -> Response
}
