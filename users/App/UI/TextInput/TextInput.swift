//
//  TextInput.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TextInput: UIView {
    
    fileprivate let titleLabel = UILabel()
    fileprivate let inputTextField = UITextField()
    fileprivate let devider = UIView()
    fileprivate let style: TextInputStyle
    
    private let disposeBag = DisposeBag()
    
    init(style: TextInputStyle) {
        self.style = style
        super.init(frame: .zero)
        createUI()
        configureUI()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        [titleLabel, inputTextField, devider].forEach { addSubview($0) }
    }
    
    private func configureUI() {
        inputTextField.borderStyle = .none
        inputTextField.textColor = style.textColor
        devider.backgroundColor = style.activeColor
        titleLabel.textColor = style.activeColor
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(8)
        }
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        devider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(inputTextField.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(8)
        }
    }
}

extension TextInput: FlowableConfiguration {
    
    func configure(input: TextInput.Input) -> TextInput.Output? {
        let outputText = inputTextField.rx.text.asDriver()
        input.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        let checkError: Driver<Bool> = input.check
            .withLatestFrom(outputText)
            .map { ($0 ?? "").isEmpty }
        let textChaged: Driver<Bool> = outputText.map(to: false)
        let isError = Driver.merge(checkError, textChaged)
        isError
            .drive(rx.isError)
            .disposed(by: disposeBag)
        input.text
            .distinctUntilChanged()
            .drive(inputTextField.rx.text)
            .disposed(by: disposeBag)
        return Output(text: outputText)
    }
    
    struct Input {
        let check: Driver<Void>
        let isError: Driver<Void>
        let title: Driver<String>
        let text: Driver<String?>
    }
    
    struct Output {
        let text: Driver<String?>
    }
}

private extension Reactive where Base: TextInput {
    var isError: Binder<Bool> {
        return Binder(base) { textInput, isError in
            let color = isError ? textInput.style.errorColor : textInput.style.activeColor
            textInput.devider.backgroundColor = color
            textInput.titleLabel.textColor = color
        }
    }
}
