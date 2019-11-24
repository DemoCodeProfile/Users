//
//  AddUserRouter.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddUserRouterProtocol {
    
}

final class AddUserRouter: AddUserRouterProtocol {
    private weak var viewController: UIViewController?
    
    func setViewController(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
