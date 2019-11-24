//
//  AddUserViewModel.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddUserViewModelProtocol {
    func configure(input: AddUserViewModel.Input) -> AddUserViewModel.Output
}

final class AddUserViewModel: AddUserViewModelProtocol {
    
    private let provider: AddUserProviderProtocol
    private let service: AddUserServiceProtocol

    init(service: AddUserServiceProtocol, provider: AddUserProviderProtocol) {
        self.service = service
        self.provider = provider
    }
    
    func configure(input: AddUserViewModel.Input) -> AddUserViewModel.Output {
        let inputProvider = AddUserProvider.Input()
        let inputService = AddUserService.Input(sendUser: input.sendUser.asObservable())
        let outputProvider = provider.configure(input: inputProvider)
        let outputService = service.configure(input: inputService)
        let response = outputService.response
            .map { $0.value }
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
        let error = outputService.response
            .map { $0.error?.description }
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
        return AddUserViewModel.Output(
            response: response,
            error: error
        )
    }
}

extension AddUserViewModel: Flowable {
    struct Input {
        let sendUser: Driver<User>
    }
    struct Output {
        let response: Driver<User>
        let error: Driver<String>
    }
}
