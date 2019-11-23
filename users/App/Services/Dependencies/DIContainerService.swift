//
//  DIContainerService.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation

protocol DIContainerProtocol {
    associatedtype Scope
    /**
    Method register dependency into DI container
    */
    func register<T>(depedency: T.Type, implemenation: @escaping () -> T, objectScope: Scope, tag: String?)
    /**
    Method receive dependency from DI container
     - parameters:
        - dependency: the type of dependency you want to get
     - returns: current dependency
    */
    func resolve<T>(_ dependency: T.Type, tag: String?) -> T
}

protocol DIContainerServiceProtocol {
    func registerServices()
    func resolve<T>(_ dependency: T.Type) -> T
}

