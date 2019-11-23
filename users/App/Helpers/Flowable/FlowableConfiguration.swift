//
//  FlowableConfiguration.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

protocol FlowableConfiguration: Flowable {
    /**
    Method configuration assemby
     - parameters:
        - input: Input data from view or vc
     - returns: Output data from this view or vc
    */
    func configure(input: Input) -> Output?
}
