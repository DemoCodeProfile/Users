//  ActivityIndicatorView.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ActivityIndicatorView {
  let activityIndicatorViewController: ActivityIndicatorViewController
  static let instance = ActivityIndicatorView()

  init() {
    activityIndicatorViewController = ActivityIndicatorViewController()
  }

  func show() {
    let topViewController = UIViewController.getTopViewController()
    activityIndicatorViewController.modalPresentationStyle = .overCurrentContext
    topViewController?.present(activityIndicatorViewController, animated: false, completion: nil)
  }

  func hide() {
    activityIndicatorViewController.dismiss(animated: false) { 
      let topViewController = UIViewController.getTopViewController()
      topViewController?.setNeedsStatusBarAppearanceUpdate()
    }
  }

  func showChild() {
    let topViewController = UIViewController.getTopViewController()
    topViewController?.add(activityIndicatorViewController)
    activityIndicatorViewController.view.frame = topViewController?.view.frame ?? .zero
  }

  func hideChild() {
    activityIndicatorViewController.remove()
  }
}

extension SharedSequence {
  func activityIndicator() -> SharedSequence {
    return self.do(onNext: { _ in
        ActivityIndicatorView.instance.hide()
      }, onSubscribe: {
        ActivityIndicatorView.instance.show()
      })
  }
  func activityIndicatorChild() -> SharedSequence {
    return self.do(onNext: { _ in
      ActivityIndicatorView.instance.hideChild()
    }, onSubscribe: {
      ActivityIndicatorView.instance.showChild()
    })
  }
}
