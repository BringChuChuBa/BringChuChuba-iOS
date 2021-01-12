//
//  CreateMissionViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class CreateMissionViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: CreateMissionViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // 폰트 사이즈, cornerRadius 추가

    private lazy var saveBarButtonItem: UIBarButtonItem = UIBarButtonItem().then { button in
        button.title = "save" // 추후 이미지로 교체
        button.style = .done
    }

    private lazy var pointLabel: UILabel = UILabel().then { label in
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(15)
    }

    private lazy var titleTextField: UITextField = UITextField().then { field in
        // custom
        field.placeholder = "title"
        field.font = .systemFont(ofSize: 13)

        // default
        field.keyboardType = .default
        field.returnKeyType = .done
        field.autocorrectionType = .no
        field.borderStyle = .roundedRect
        field.clearButtonMode = .whileEditing
        field.contentVerticalAlignment = .center
        field.keyboardAppearance = .default
        field.autocapitalizationType = .none
    }

    private lazy var rewardView: UIView = UIView().then { view in
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 5
    }

    private lazy var rewardButton: UIButton = UIButton(type: .system).then { button in
        button.setTitle("reward", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(13)
        button.contentHorizontalAlignment = .left
    }

    //    날짜 형식
    //    "yyyy-MM-dd HH:mm"

//    private lazy var datePicker: UIDatePicker = UIDatePicker().then { picker in
//        picker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        picker.datePickerMode = .dateAndTime
//        picker.locale = .current
//        if #available(iOS 13.4, *) {
//            picker.preferredDatePickerStyle = .compact
//            picker.sizeToFit()
//        }
//    }

    private lazy var expireDateView: UIView = UIView().then { view in
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 5
    }

    private lazy var expireDateButton: UIButton = UIButton(type: .system).then { button in
        button.setTitle("expireDate", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(13)
        button.contentHorizontalAlignment = .left
    }

    private lazy var descriptionTextField: UITextField = UITextField().then { field in
        // custom
        field.placeholder = "description"
        field.font = .systemFont(ofSize: 13)

        // default
        field.keyboardType = .default
        field.returnKeyType = .done
        field.autocorrectionType = .no
        field.borderStyle = .roundedRect
        field.clearButtonMode = .whileEditing
        field.contentVerticalAlignment = .center
        field.keyboardAppearance = .default
        field.autocapitalizationType = .none
    }

    // MARK: - Initializers
    init(viewModel: CreateMissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }
}

// MARK: - Binds
extension CreateMissionViewController {
    private func bindViewModel() {
        assert(viewModel.isSome)

        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let input = CreateMissionViewModel.Input(
            appear: viewWillAppear,
            title: titleTextField.rx.text.orEmpty.asDriver(),
            description: descriptionTextField.rx.text.orEmpty.asDriver(),
            reward: rewardButton.rx.tap.asDriver(),
            expireDate: expireDateButton.rx.tap.asDriver(), // expireDateTextField.rx.text.orEmpty.asDriver(),
            saveTrigger: saveBarButtonItem.rx.tap.asDriver()
        )

        let output = viewModel.transform(input: input)

        output.point
            .drive(pointLabel.rx.text)
            .disposed(by: disposeBag)

        output.toReward
            .drive()
            .disposed(by: disposeBag)

        output.test
            .drive()
            .disposed(by: disposeBag)

        output.showPicker
            .drive(expireDateButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        output.saveEnabled
            .drive(saveBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - Set UIs
extension CreateMissionViewController {
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)

        navigationItem.rightBarButtonItem = saveBarButtonItem

        // add subviews
        view.addSubview(pointLabel)
        view.addSubview(titleTextField)

        view.addSubview(rewardView)
        rewardView.addSubview(rewardButton)

        view.addSubview(expireDateView)
        expireDateView.addSubview(expireDateButton)

        view.addSubview(descriptionTextField)

        pointLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }

        rewardView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(titleTextField)
        }

        rewardButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }

        expireDateView.snp.makeConstraints { make in
            make.top.equalTo(rewardView.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(titleTextField)
        }

        expireDateButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }

        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(expireDateView.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(titleTextField)
        }
    }
}
