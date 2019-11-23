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
    
}

final class UserListRouter: UserListRouterProtocol {
    private weak var viewController: UIViewController?
    
    func setViewController(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
