//
//  UserListViewController.swift
//  users
//
//  Copyright (c) 2019 Вадим. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

final class UserListViewController: UIViewController {
    
    struct Constants {
        static let identityUserCell = "UserCell"
    }

    private let viewModel: UserListViewModelProtocol
    private let router: UserListRouterProtocol

    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    private let plug = Plug()
    private let addButton = UIBarButtonItem(image: R.image.cross(), style: .plain, target: nil, action: nil)
    private var users: [User] = []
    
    init(viewModel: UserListViewModelProtocol, router: UserListRouterProtocol) {
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
        navigationItem.title = R.string.localizable.listUsers()
    }
    
    private func createUI() {
        [tableView, plug].forEach { view.addSubview($0) }
    }
    
    private func configureUI() {
        let nib = UINib(nibName: Constants.identityUserCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.identityUserCell)
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func layout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        plug.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension UserListViewController: FlowableViewController {
    typealias Configuration = UserListConfiguration
    
    func configure(input: UserListConfiguration.Input) -> UserListConfiguration.Output {
        let getUsers = BehaviorRelay<Void>(value: ())
        let inputViewModel = UserListViewModel.Input(getUsers: getUsers.asDriver())
        let outputViewModel = viewModel.configure(input: inputViewModel)
        let inputPlug = Plug.Input(textPlug: outputViewModel.error)
        let outputPlug = plug.configure(input: inputPlug)
        outputPlug?.didTapReply
            .asDriver(onErrorJustReturn: ())
            .drive(getUsers)
            .disposed(by: disposeBag)
        let hideActivityIndicator = Driver.merge(
            outputViewModel.error.mapToVoid(),
            outputViewModel.users.mapToVoid()
        )
            .map(to: false)
        let showActivityIndicator = getUsers
            .asDriver(onErrorJustReturn: ())
            .map(to: true)
        let activityIndicator = Driver.merge(
            hideActivityIndicator,
            showActivityIndicator
        )
        Driver.merge(
            outputViewModel.error.map(to: false),
            getUsers.asDriver(onErrorJustReturn: ()).map(to: true)
        )
            .drive(plug.rx.isHidden)
            .disposed(by: disposeBag)
        tapAddButton()
        activityIndicatorVisibility(show: activityIndicator)
        updateUsers(users: outputViewModel.users)
        return UserListConfiguration.Output()
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
    
    /**
    Update users list when load data from server.
     - parameters:
        - users: array users
    */
    private func updateUsers(users: Driver<[User]>) {
        users.drive(onNext: { [weak self] users in
            self?.users = users
            self?.tableView.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
    /**
    Tap and segue to AddUserViewController
    */
    private func tapAddButton() {
        addButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                _ = self?.router.showAddUserScreen(input: AddUserConfiguration.Input(transition: .push))
            })
            .disposed(by: disposeBag)
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identityUserCell) as? UserCell
        let model = users[indexPath.row]
        if let photo = model.avatarUrl, !photo.isEmpty {
            cell?.avatarImageView.sd_setImage(with: URL(string: photo), placeholderImage: R.image.noPhoto())
        }
        cell?.titleLabel.text = (model.firstName ?? "") + " " + (model.lastName ?? "")
        cell?.subtitleLabel.text = model.email
        return cell ?? UITableViewCell()
    }
}
