//
//  UIViewController+Ext.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum TransitionScreen {
    case push
    case show
    case present
    case add
    case none
}

extension UIViewController {
    
    //    MARK: - Routing
    public static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = base as? UINavigationController {
            return getTopViewController(base: navigationController.visibleViewController)
        } else if let tabBarController = base as? UITabBarController,
            let selected = tabBarController.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    func showScreen(_ transition: TransitionScreen) {
        switch transition {
        case .push:
            push()
        case .show:
            show()
        case .present:
            present()
        case .add:
            addChild()
        default: break
        }
    }
    
    private func show() {
        UIViewController.getTopViewController()?.show(self, sender: nil)
    }
    
    private func push() {
        UIViewController.getTopViewController()?.navigationController?.pushViewController(self, animated: true)
    }
    
    private func present() {
        UIViewController.getTopViewController()?.present(self, animated: true, completion: nil)
    }
    
    private func addChild() {
        let topViewController = UIViewController.getTopViewController()
        topViewController?.add(self)
        self.view.frame = topViewController?.view.frame ?? .zero
    }
    
    //    MARK: - ChildViewController
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func showError() {
        let plug = Plug(frame: view.frame)
        view.addSubview(plug)
    }
    
    func plugView(error: Driver<String>) -> Driver<Void> {
        let plug = Plug(frame: view.frame)
        let output = plug.configure(input: Plug.Input(textPlug: error))
        view.addSubview(plug)
        let didTapReply = output?.didTapReply.do(onNext: { _ in
            plug.removeFromSuperview()
        })
        return didTapReply ?? .empty()
    }
    
    func presentModal(modalPresentationStyle: UIModalPresentationStyle = .overCurrentContext) {
        self.modalPresentationStyle = modalPresentationStyle
        UIViewController.getTopViewController()?.present(self, animated: true, completion: nil)
    }
}
