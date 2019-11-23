//
//  UserListService.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UserListServiceProtocol {
    func configure(input: UserListService.Input) -> UserListService.Output
}

final class UserListService: UserListServiceProtocol {
   
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func configure(input: UserListService.Input) -> UserListService.Output {
        let users = input.getUsers.flatMapLatest { [weak self] _ -> Observable<Result<[User], ServiceError>> in
            guard let `self` = self else { return .empty() }
            return self.userService.getUsers()
        }
        return UserListService.Output(users: users)
    }
}

extension UserListService: Flowable {
    struct Input {
        let getUsers: Observable<Void>
    }
    struct Output {
        let users: Observable<Result<[User], ServiceError>>
    }
}
