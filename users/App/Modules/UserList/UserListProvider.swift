//
//  UserListProvider.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UserListProviderProtocol {
    func configure(input: UserListProvider.Input) -> UserListProvider.Output
}

final class UserListProvider: UserListProviderProtocol {
    func configure(input: UserListProvider.Input) -> UserListProvider.Output {
        return UserListProvider.Output()
    }
}

extension UserListProvider: Flowable {
    struct Input {
        
    }
    struct Output {
        
    }
}
