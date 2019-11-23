//
//  UserListConfiguration.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import Foundation
import RxSwift

protocol UserListConfigurationProtocol { }

final class UserListConfiguration: UserListConfigurationProtocol {
    
    let viewController: UIViewController?

    init() {
        let userService = DependencyInjection.instance.container.resolve(UserServiceProtocol.self)
        let provider = UserListProvider()
        let service = UserListService(userService: userService)
        let router = UserListRouter()
        let viewModel = UserListViewModel(service: service, provider: provider)
        viewController = UserListViewController(viewModel: viewModel, router: router)
        router.setViewController(viewController: viewController)
    }
}

extension UserListConfiguration: FlowableConfiguration {
    
    @discardableResult
    func configureStart(input: Input) -> Output? {
        return (viewController as? UserListViewController)?.configure(input: input)
    }
    
    func configure(input: Input) -> Output? {
        let output = configureStart(input: input)
        viewController?.showScreen(input.transition)
        return output
    }
    
    struct Input {
        let transition: TransitionScreen
    }
    
    struct Output {
        
    }
}

