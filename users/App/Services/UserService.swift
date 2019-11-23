//
//  UserService.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Moya
import RxSwift

protocol UserServiceProtocol {
    /**
    Method receive users list
     - returns: Users list
    */
    func getUsers() -> Observable<Result<[User], ServiceError>>
    
    /**
    Method add user to server
     - returns: Add user success
    */
    func addUser(params: [String: [String: String]]) -> Observable<Result<User, ServiceError>>
}

class UserService: UserServiceProtocol {
    
    private let providerMoya: MoyaProvider<ServerAPI>
    private let scheduler: SchedulerType
    
    init(providerMoya: MoyaProvider<ServerAPI>, scheduler: SchedulerType) {
        self.providerMoya = providerMoya
        self.scheduler = scheduler
    }
    
    func getUsers() -> Observable<Result<[User], ServiceError>> {
        return serverRequest(target: .getUsers)
    }
    
    func addUser(params: [String: [String: String]]) -> Observable<Result<User, ServiceError>> {
        return serverRequest(target: .addUser(params))
    }
    
    private func serverRequest<T: Decodable>(target: ServerAPI) -> Observable<Result<T, ServiceError>> {
        guard Reachability.isConnectedToNetwork() else { return .just(.failure(.noСonnection)) }
        return Observable<Result<T, ServiceError>>
            .create { [weak self] observer -> Disposable in
                guard let `self` = self else { return Disposables.create() }
                self.providerMoya.request(target) { result in
                    if let error = result.error {
                        observer.onNext(.failure(.moya(error.errorDescription ?? "")))
                    }
                    if let response = result.value, let models = try? response.map(T.self) {
                        switch response.statusCode {
                        case 200...299: observer.onNext(.success(models))
                        default: observer.onNext(.failure(.server))
                        }
                    }
                }
                return Disposables.create()
        }
        .subscribeOn(scheduler)
    }
}
