//
//  FlowableViewController.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

protocol FlowableViewController {
    associatedtype Configuration: FlowableConfiguration
    /**
    Method for binding data to view
     - parameters:
        - input: Input data from VC
     - returns: Output data from this controller
    */
    func configure(input: Configuration.Input) -> Configuration.Output
}
