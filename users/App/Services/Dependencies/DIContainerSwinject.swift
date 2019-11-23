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
