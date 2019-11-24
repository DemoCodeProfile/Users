//
//  MTMPlug.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class Plug: UIView {
    private let disposeBag = DisposeBag()
    
    private let descriptionLabel = UILabel()
    private let replyButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
        configureUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        [descriptionLabel, replyButton].forEach { addSubview($0) }
    }
    
    private func configureUI() {
        isHidden = true
        backgroundColor = Theme.colors.background
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        replyButton.setTitle(R.string.localizable.retry(), for: .normal)
        replyButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    private func layout() {
        descriptionLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        replyButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}

extension Plug: FlowableConfiguration {
    func configure(input: Plug.Input) -> Plug.Output? {
        input.textPlug
            .drive(onNext: { [weak self] text in
                self?.descriptionLabel.text = text
                self?.layoutSubviews()
            })
            .disposed(by: disposeBag)
        return Output(didTapReply: replyButton.rx.tap.asDriver())
    }
    
    struct Input {
        let textPlug: Driver<String>
    }
    struct Output {
        let didTapReply: Driver<Void>
    }
}
