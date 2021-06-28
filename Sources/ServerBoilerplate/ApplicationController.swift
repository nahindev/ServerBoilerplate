import GRPCServer
import GRPC
import Vapor

public struct ApplicationController {
    public init(routes: [RouteCollection] = [], services: [Service.Type] = [], configure: (Application) throws -> Void) throws {
        try self.init()
        try configureRoutes(routes: routes)
        configureServices(services: services)
        try configure(application)
    }
    
    public init(providers: [VaporCallHandlerProvider.Type], services: [Service.Type] = [], configure: (Application) throws -> Void) throws {
        try self.init()
        configureGRPC(providers: providers)
        configureServices(services: services)
        try configure(application)
    }
    
    // MARK: - Private
    
    private let application: Application
    
    private init() throws {
        var environment = try Environment.detect()
        try LoggingSystem.bootstrap(from: &environment)
        self.application = Application(environment)
    }
    
    private func configureRoutes(routes: [RouteCollection]) throws {
        application.servers.use(.http)
        application.http.server.configuration.hostname = "0.0.0.0"
        application.http.server.configuration.port = 8080
        
        try routes.forEach { try application.register(collection: $0) }
    }
    
    private func configureGRPC(providers: [VaporCallHandlerProvider.Type]) {
        application.servers.use(.grpc)
        application.grpc.server.configuration.hostname = "0.0.0.0"
        application.grpc.server.configuration.port = 8080
        
        application.grpc.server.configuration.providers = providers
            .map { $0.init(application: application) }
    }
    
    private func configureServices(services: [Service.Type]) {
        application.services.add(services)
    }
}
