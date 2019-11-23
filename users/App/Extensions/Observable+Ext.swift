//
//  Observable+Ext.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import RxSwift

extension Observable {
    func filterNil<T>() -> Observable<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
