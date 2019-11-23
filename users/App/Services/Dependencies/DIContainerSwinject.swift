//
//  DIContainerSwinject.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Swinject
import Moya
import RxSwift

class DIContainerSwinject: DIContainerProtocol {
    private let container = Container()
    
    func register<T>(
        depedency: T.Type,
        implemenation: @escaping () -> T,
        objectScope: ObjectScope = .graph,
        tag: String? = nil
    ) {
        container.register(depedency, name: tag, factory: { _ in implemenation() }).inObjectScope(objectScope)
    }
    
    func resolve<T>(_ dependency: T.Type, tag: String? = nil) -> T {
      guard let implementation = container.resolve(dependency, name: tag) else {
        fatalError("Not found")
      }
      return implementation
    }
}

class DIContainerService: DIContainerServiceProtocol {
    private let container = DIContainerSwinject()
    
    /**
    Method register dependencies into DI container
    */
    func registerServices() {
        container.register(
            depedency: MoyaProvider<ServerAPI>.self,
            implemenation: {
                let networkLogger = NetworkLoggerPlugin(verbose: true)
                return MoyaProvider<ServerAPI>(plugins: [networkLogger])
        })
        container.register(
            depedency: UserServiceProtocol.self,
            implemenation: { [weak self] () -> UserService in
                guard let `self` = self else { fatalError("Fatal error container") }
                return UserService(
                    providerMoya: self.resolve(MoyaProvider<ServerAPI>.self),
                    scheduler: ConcurrentDispatchQueueScheduler(qos: .default)
                )
        })
    }
    
    /**
    Method receive dependency from DI container
     - parameters:
        - dependency: the type of dependency you want to get
     - returns: current dependency
    */
    func resolve<T>(_ dependency: T.Type) -> T {
        return container.resolve(dependency)
    }
}
