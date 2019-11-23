//
//  ActivityIndicatorViewController.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit

final class ActivityIndicatorViewController: UIViewController {

  private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()
    createUI()
    configureUI()
    layout()
  }

  private func createUI() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    [
      blurEffectView,
      activityIndicator
      ]
      .forEach { view.addSubview($0) }
  }

  private func configureUI() {
    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0)
    activityIndicator.style = .white
    activityIndicator.color = UIColor.gray
    activityIndicator.startAnimating()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.95)
    view.isOpaque = false
  }

  private func layout() {
    activityIndicator.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.size.equalTo(40)
    }
  }
}
