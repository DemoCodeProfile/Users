//
//  ServiceError.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case moya(String)
    case server
    case noСonnection
}

extension ServiceError {
    var description: String {
        switch self {
        case .moya(let description):
            return description
        case .server:
            return R.string.localizable.serverError()
        case .noСonnection:
            return R.string.localizable.noConnection()
        }
    }
}
