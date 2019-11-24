//
//  UserListRouter.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UserListRouterProtocol {
    func showAddUserScreen(input: AddUserConfiguration.Input) -> AddUserConfiguration.Output?
}

final class UserListRouter: UserListRouterProtocol {
    
    private weak var viewController: UIViewController?
    
    func setViewController(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAddUserScreen(input: AddUserConfiguration.Input) -> AddUserConfiguration.Output? {
        return AddUserConfiguration().configure(input: input)
    }
}
