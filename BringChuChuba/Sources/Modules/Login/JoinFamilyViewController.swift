//
//  RegisterViewController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/12.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class JoinFamilyViewController: UIViewController {
    // MARK: Properties
    private var viewModel: JoinFamilyViewModel!
    private var disposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var familyIdTextField = UITextField().then {
        $0.placeholder = "JoinFamily.FamilyIdTextField.Placeholder".localized
        $0.autocapitalizationType = .none
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray.cgColor
        // 왼쪽 inset padding 추가
    }

    private lazy var joinFamilyButton = UIButton().then {
        $0.setTitle("JoinFamily.JoinFamilyButton.Title".localized, for: .normal)
        $0.backgroundColor = UIColor.systemBlue
        $0.layer.cornerRadius = 5
    }

    private lazy var createFamilyButton = UIButton().then {
        let attributedString = NSAttributedString(
            string: "JoinFamily.CreateFamilyButton.Title".localized,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
                NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                NSAttributedString.Key.underlineStyle: 1.0
            ]
        )
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.layer.cornerRadius = 5
    }

    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }

    private var errorBinding: Binder<Error> {
        return Binder(self) { vc, _ in
            let alert = UIAlertController(
                title: "JoinFamily.Alert.Title".localized,
                message: "JoinFamily.Alert.Message".localized,
                preferredStyle: .alert
            )
            let action = UIAlertAction(
                title: "JoinFamily.Alert.DismissButton.Title".localized,
                style: .cancel,
                handler: nil
            )
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: Initializers
    init(viewModel: JoinFamilyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
    }

    // MARK: Binds
    private func bindViewModel() {
        let input = JoinFamilyViewModel.Input(
            familyId: familyIdTextField.rx.text.orEmpty.asDriver(),
            joinTrigger: joinFamilyButton.rx.tap.asDriver(),
            createTrigger: createFamilyButton.rx.tap.asDriver()
        )

        let output = viewModel.transform(input: input)

        [output.joinEnabled
            .drive(joinFamilyButton.rx.isEnabled),
         output.join
            .drive(),
         output.toCreateFamily
            .drive(),
         output.error
            .drive(errorBinding)
        ]
        .forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemBackground

        navigationItem.title = "JoinFamily.Navigation.Title".localized

        view.addSubview(stackView)
        stackView.addArrangedSubview(familyIdTextField)
        //        stackView.addArrangedSubview(memberNameTextField)
        stackView.addArrangedSubview(joinFamilyButton)
        stackView.addArrangedSubview(createFamilyButton)

        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(view)
        }

        familyIdTextField.snp.makeConstraints { make in
            make.height.equalTo(joinFamilyButton)
        }
    }
}
