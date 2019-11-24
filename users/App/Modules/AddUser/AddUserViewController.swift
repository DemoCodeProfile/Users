//
//  AddUserViewController.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AddUserViewController: UIViewController {

    private let viewModel: AddUserViewModelProtocol
    private let router: AddUserRouterProtocol

    private let disposeBag = DisposeBag()
    
    private let nameTextField = UITextField()
    private let lastNameTextField = UITextField()
    private let emailTextField = UITextField()
    private let addButton = UIButton()
    private let plug = Plug()
    
    init(viewModel: AddUserViewModelProtocol, router: AddUserRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error decoder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        configureUI()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = R.string.localizable.addUser()
    }
    
    private func createUI() {
        [
            nameTextField,
            lastNameTextField,
            emailTextField,
            addButton,
            plug
            ]
            .forEach { view.addSubview($0) }
    }
    
    private func configureUI() {
        view.backgroundColor = Theme.colors.background
        [
        nameTextField,
        lastNameTextField,
        emailTextField
        ]
        .forEach {
            $0.layer.cornerRadius = 5
            $0.layer.borderColor = Theme.colors.body.cgColor
            $0.layer.borderWidth = 1
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
            $0.leftViewMode = .always
        }
        addButton.layer.cornerRadius = 5
        addButton.backgroundColor = Theme.colors.main
        addButton.setTitle(R.string.localizable.add(), for: .normal)
        addButton.tintColor = .white
        nameTextField.placeholder = R.string.localizable.firstName()
        lastNameTextField.placeholder = R.string.localizable.lastName()
        emailTextField.placeholder = R.string.localizable.email()
    }
    
    private func layout() {
        nameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        lastNameTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(lastNameTextField.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        addButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        plug.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//  MARK: - FlowableViewController
extension AddUserViewController: FlowableViewController {
    typealias Configuration = AddUserConfiguration
    
    func configure(input: AddUserConfiguration.Input) -> AddUserConfiguration.Output {
        let sendUser = PublishRelay<User?>()
        let inputViewModel = AddUserViewModel.Input(sendUser: sendUser.asDriver(onErrorJustReturn: nil).filterNil())
        let outputViewModel = viewModel.configure(input: inputViewModel)
        let inputPlug = Plug.Input(textPlug: outputViewModel.error)
        let outputPlug = plug.configure(input: inputPlug)
        let hideActivityIndicator = Driver.merge(
            outputViewModel.error.mapToVoid(),
            outputViewModel.response.mapToVoid()
        )
            .map(to: false)
        let showActivityIndicator = sendUser
            .asDriver(onErrorJustReturn: nil)
            .map(to: true)
        let activityIndicator = Driver.merge(
            hideActivityIndicator,
            showActivityIndicator
        )
        Driver.merge(
            outputViewModel.error.map(to: false),
            outputPlug?.didTapReply.map(to: true) ?? .empty()
        )
            .drive(plug.rx.isHidden)
            .disposed(by: disposeBag)
        outputViewModel.response
            .drive(onNext: { [weak self] user in
                let alertController = UIAlertController(
                    title: R.string.localizable.addUser(),
                    message: R.string.localizable.userAdded(),
                    preferredStyle: .alert
                )
                let action = UIAlertAction(title: R.string.localizable.ok(), style: .cancel, handler: nil)
                alertController.addAction(action)
                self?.present(alertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        addButton.rx.tap
            .asDriver()
            .map { [weak self] _ -> User? in
                guard let `self` = self else { return nil }
                return User(
                    id: 0,
                    firstName: self.nameTextField.text,
                    lastName: self.lastNameTextField.text,
                    email: self.emailTextField.text,
                    avatarUrl: nil
                )
            }
            .drive(onNext: sendUser.accept)
            .disposed(by: disposeBag)
        activityIndicatorVisibility(show: activityIndicator)
        return AddUserConfiguration.Output()
    }
    
    /**
    Show and hide activityIndicator.
     - parameters:
        - show: show or hide activityIndicator
    */
    private func activityIndicatorVisibility(show: Driver<Bool>) {
        show.drive(onNext: { isShow in
            if isShow {
                ActivityIndicatorView.instance.show()
                return
            }
            ActivityIndicatorView.instance.hide()
        })
        .disposed(by: disposeBag)
    }
}
