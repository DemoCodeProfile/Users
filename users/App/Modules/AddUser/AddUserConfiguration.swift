//
//  AddUserConfiguration.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import Foundation
import RxSwift

protocol AddUserConfigurationProtocol { }

final class AddUserConfiguration: AddUserConfigurationProtocol {
    
    let viewController: UIViewController?

    init() {
        let userService = DependencyInjection.instance.container.resolve(UserServiceProtocol.self)
        let provider = AddUserProvider()
        let service = AddUserService(userService: userService)
        let router = AddUserRouter()
        let viewModel = AddUserViewModel(service: service, provider: provider)
        viewController = AddUserViewController(viewModel: viewModel, router: router)
        router.setViewController(viewController: viewController)
    }
}

extension AddUserConfiguration: FlowableConfiguration {
    
    @discardableResult
    func configureStart(input: Input) -> Output? {
        return (viewController as? AddUserViewController)?.configure(input: input)
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
