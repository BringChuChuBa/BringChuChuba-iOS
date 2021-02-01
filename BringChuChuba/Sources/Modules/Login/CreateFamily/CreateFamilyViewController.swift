//
//  ViewController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class CreateFamilyViewController: UIViewController {
    // MARK: Properties
    private let viewModel: CreateFamilyViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Components
    private lazy var familyNameTextField = UITextField().then {
        $0.placeholder = "CreateFamily.FamilyNameTextField.Placeholder".localized
        $0.autocapitalizationType = .none
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray.cgColor
        // 왼쪽 inset padding 추가
    }
    
    private lazy var createFamilyButton = UIButton().then {
        $0.setTitle("CreateFamily.CreateFamilyButton.Title".localized, for: .normal)
        $0.backgroundColor = UIColor.systemBlue
        $0.layer.cornerRadius = 5
    }
    
    private lazy var joinFamilyButton = UIButton().then {
        let attributedString = NSAttributedString(
            string: "CreateFamily.JoinFamilyButton.Title".localized,
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
    
    // MARK: Initializers
    init(viewModel: CreateFamilyViewModel) {
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
        let input = CreateFamilyViewModel.Input(
            familyName: familyNameTextField.rx.text.orEmpty.asDriver(),
            createTrigger: createFamilyButton.rx.tap.asDriver(),
            joinTrigger: joinFamilyButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        [output.createEnable
            .drive(createFamilyButton.rx.isEnabled),
         output.create
            .drive(),
         output.toJoin
            .drive(),
         output.error
            .drive(errorBinding)
        ].forEach { $0.disposed(by: disposeBag) }
    }
    
    private var errorBinding: Binder<Error> {
        return Binder(self) { vc, _ in
            let alert = UIAlertController(
                title: "CreateFamily.Alert.Title".localized,
                message: "CreateFamily.Alert.Message".localized,
                preferredStyle: .alert
            )
            let action = UIAlertAction(
                title: "CreateFamily.Alert.DismissButton.Title".localized,
                style: .cancel,
                handler: nil
            )
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "CreateFamily.Navigation.Title".localized
        navigationItem.hidesBackButton = true
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(familyNameTextField)
        stackView.addArrangedSubview(createFamilyButton)
        stackView.addArrangedSubview(joinFamilyButton)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(view)
        }
        
        familyNameTextField.snp.makeConstraints { make in
            make.height.equalTo(joinFamilyButton)
        }
    }
}
