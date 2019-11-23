//
//  ServerAPI.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Moya

enum ServerAPI {
    case getUsers
    case addUser([String: [String: String]])
}

extension ServerAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://frogogo-test.herokuapp.com")!
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users.json"
        case .addUser:
            return "/users.json"
        }
    }
    
    var method: Method {
        switch self {
        case .getUsers:
            return .get
        case .addUser:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getUsers:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .addUser(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
