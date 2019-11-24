//
//  AddUserProvider.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AddUserProviderProtocol {
    func configure(input: AddUserProvider.Input) -> AddUserProvider.Output
}

final class AddUserProvider: AddUserProviderProtocol {
    func configure(input: AddUserProvider.Input) -> AddUserProvider.Output {
        return AddUserProvider.Output()
    }
}

extension AddUserProvider: Flowable {
    struct Input {
        
    }
    struct Output {
        
    }
}
