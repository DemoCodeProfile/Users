//
//  AddUserService.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AddUserServiceProtocol {
    func configure(input: AddUserService.Input) -> AddUserService.Output
}

final class AddUserService: AddUserServiceProtocol {
    
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func configure(input: AddUserService.Input) -> AddUserService.Output {
        let response = input.sendUser
            .flatMapLatest { [weak self] user -> Observable<Result<User, ServiceError>> in
                guard let `self` = self else { return .empty() }
                let userParams = [
                    "first_name": user.firstName,
                    "last_name": user.lastName,
                    "email": user.email,
                    "avatar_url": user.avatarUrl
                ]
                    .compactMapValues { $0 }
                return self.userService.addUser(params: ["user": userParams])
        }
        return AddUserService.Output(response: response)
    }
}

extension AddUserService: Flowable {
    struct Input {
        let sendUser: Observable<User>
    }
    struct Output {
        let response: Observable<Result<User, ServiceError>>
    }
}
