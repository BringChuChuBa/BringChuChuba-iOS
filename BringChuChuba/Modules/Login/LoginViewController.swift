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
    private var viewModel: LoginViewModel
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private lazy var familyIdTextField = UITextField().then {
        $0.placeholder = "Enter family ID"
        $0.autocapitalizationType = .none
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray.cgColor
        // 왼쪽 inset padding 추가
    }

    private lazy var memberNameTextField = UITextField().then {
        $0.placeholder = "Enter your name"
        $0.autocapitalizationType = .none
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray.cgColor
    }

    private lazy var joinFamilyButton = UIButton().then {
        $0.setTitle("Find and join a family", for: .normal)
        $0.backgroundColor = UIColor.systemBlue
        $0.layer.cornerRadius = 5
    }

    private lazy var createFamilyButton = UIButton().then {
        let attributedString = NSAttributedString(string: NSLocalizedString("or Create new family", comment: ""),
            attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
            NSAttributedString.Key.underlineStyle: 1.0
        ])
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.layer.cornerRadius = 5
    }

    private lazy var stackView = UIStackView().then {
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

        bind()
        setupUI()
    }

    // MARK: - Private Method
    private func setupUI() {
        title = "Join Family"
        view.addSubview(stackView)
        stackView.addArrangedSubview(familyIdTextField)
        stackView.addArrangedSubview(joinFamilyButton)
        stackView.addArrangedSubview(createFamilyButton)

        view.backgroundColor = .systemBackground

        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(view)
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

//        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
//            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
//        }).disposed(by: rx.disposeBag)

        [output.joinEnabled
            .drive(joinFamilyButton.rx.isEnabled),
         output.join
            .drive(),
         output.toCreate
            .drive(),
         output.error
            .drive(errorBinding)
        ].forEach { $0.disposed(by: disposeBag) }
    }

    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, _) in
            let alert = UIAlertController(title: "Login Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: .cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
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
