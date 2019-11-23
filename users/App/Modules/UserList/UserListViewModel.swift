//
//  UserListViewModel.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UserListViewModelProtocol {
    func configure(input: UserListViewModel.Input) -> UserListViewModel.Output
}

final class UserListViewModel: UserListViewModelProtocol {
    
    private let provider: UserListProviderProtocol
    private let service: UserListServiceProtocol

    init(service: UserListServiceProtocol, provider: UserListProviderProtocol) {
        self.service = service
        self.provider = provider
    }
    
    func configure(input: UserListViewModel.Input) -> UserListViewModel.Output {
        let inputProvider = UserListProvider.Input()
        let inputService = UserListService.Input(getUsers: input.getUsers.asObservable())
        let outputProvider = provider.configure(input: inputProvider)
        let outputService = service.configure(input: inputService)
        let users = outputService.users
            .map { $0.value }
            .filterNil()
            .asDriver(onErrorJustReturn: [])
        let error = outputService.users
            .map { $0.error?.description }
            .filterNil()
            .asDriver(onErrorJustReturn: "")
        return UserListViewModel.Output(
            error: error,
            users: users
        )
    }
}

extension UserListViewModel: Flowable {
    struct Input {
        let getUsers: Driver<Void>
    }
    struct Output {
        let error: Driver<String>
        let users: Driver<[User]>
    }
}
