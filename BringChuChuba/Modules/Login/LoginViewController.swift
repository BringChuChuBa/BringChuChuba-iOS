//
//  RegisterViewController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/12.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    // MARK: - Properties
    var viewModel: LoginViewModel
    let disposeBag = DisposeBag()

    // MARK: - UI Components
    lazy var familyIdTextField = UITextField().then {
        $0.placeholder = "Enter family ID"
        $0.autocapitalizationType = .none
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray.cgColor
        // 왼쪽 inset padding 추가
    }

    lazy var memberNameTextField = UITextField().then {
        $0.placeholder = "Enter your name"
        $0.autocapitalizationType = .none
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray.cgColor
    }

    lazy var joinFamilyButton = UIButton().then {
        $0.setTitle("Find and join a family", for: .normal)
        $0.backgroundColor = UIColor.systemBlue
        $0.layer.cornerRadius = 5
    }

    lazy var createFamilyButton = UIButton().then {
        let attributedString = NSAttributedString(string: NSLocalizedString("or Create new family", comment: ""),
            attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
            NSAttributedString.Key.underlineStyle: 1.0
        ])
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.layer.cornerRadius = 5
    }

    lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }

    // MARK: - Initializers

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    // MARK: - Private Method
    private func setupUI() {
        self.title = "Join Family"
        self.view.addSubview(stackView)
        self.stackView.addArrangedSubview(familyIdTextField)
        self.stackView.addArrangedSubview(joinFamilyButton)
        self.stackView.addArrangedSubview(createFamilyButton)

        self.view.backgroundColor = .systemBackground

        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(self.view)
        }

        familyIdTextField.snp.makeConstraints { make in
            make.height.equalTo(joinFamilyButton)
        }
    }

    private func bind() {
        let input = LoginViewModel.Input(
            familyId: familyIdTextField.rx.text.orEmpty.asDriver(),
            joinTrigger: joinFamilyButton.rx.tap.asDriver(),
            createTrigger: createFamilyButton.rx.tap.asDriver()
        )

        let output = viewModel.transform(input: input)

        output.joinEnabled
            .drive(joinFamilyButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.join
            .drive()
            .disposed(by: disposeBag)

        output.create
            .drive()
            .disposed(by: disposeBag)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct LoginVCRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        LoginViewController(viewModel: LoginViewModel(coordinator: LoginCoordinator(navigationController: UINavigationController())))
    }
}

@available(iOS 13.0, *)
struct LoginVCPreview: PreviewProvider {
    static var previews: some View {
        LoginVCRepresentable()
    }
}
#endif
