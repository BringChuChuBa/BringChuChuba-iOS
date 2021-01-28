//
//  CreateMissionViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class CreateMissionViewController: UIViewController {
    // MARK: Properties
    private let viewModel: CreateMissionViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: UI Components
    // 폰트 사이즈, cornerRadius 추가
    private lazy var saveBarButtonItem: UIBarButtonItem = UIBarButtonItem().then { button in
        button.title = "Common.Done".localized
        button.style = .done
    }

    private lazy var pointLabel: UILabel = UILabel().then { label in
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(15)
    }

    private lazy var titleTextField: UITextField = UITextField().then { field in
        // custom
        field.placeholder = "Common.Title".localized
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

    private lazy var rewardTextField: UITextField = UITextField().then { field in
        // custom
        field.placeholder = "Common.Reward".localized
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

//    private lazy var rewardView: UIView = UIView().then { view in
//        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        view.layer.cornerRadius = 5
//    }
//
//    private lazy var rewardButton: UIButton = UIButton(type: .system).then { button in
//        button.setTitle("reward", for: .normal)
//        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
//        button.titleLabel?.font = button.titleLabel?.font.withSize(13)
//        button.contentHorizontalAlignment = .left
//    }

    //    날짜 형식 : "yyyy-MM-dd HH:mm"
    // frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 216)
    private lazy var datePicker: UIDatePicker = UIDatePicker().then { picker in
        picker.locale = .current
        picker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        picker.datePickerMode = .dateAndTime
        picker.translatesAutoresizingMaskIntoConstraints = false
//        if #available(iOS 14.0, *) {
//            picker.preferredDatePickerStyle = .inline // .compact
//            picker.sizeToFit()
//        }
    }

    private lazy var expireDateView: UIView = UIView().then { view in
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 5
    }

    private lazy var expireDateButton: UIButton = UIButton(type: .system).then { button in
//        button.setTitle("expireDate", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(13)
        button.contentHorizontalAlignment = .left
    }

    // textView로 바꿔야하나
    private lazy var descriptionTextField: UITextField = UITextField().then { field in
        // custom
        field.placeholder = "Common.Description".localized
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

    private lazy var stackView: UIStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = 20.0
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        [titleTextField,
         rewardTextField,
         expireDateView,
         datePicker,
         descriptionTextField
        ].forEach { stack.addArrangedSubview($0) }
    }

    // MARK: Initializers
    init(viewModel: CreateMissionViewModel) {
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
        assert(viewModel.isSome)

        let input = CreateMissionViewModel.Input(title: titleTextField.rx.text.orEmpty.asDriver(),
            reward: rewardTextField.rx.text.orEmpty.asDriver(),
            expireClicked: expireDateButton.rx.tap.asDriver(),
            dateSelected: datePicker.rx.date.asDriver(),
            description: descriptionTextField.rx.text.orEmpty.asDriver(),
            saveTrigger: saveBarButtonItem.rx.tap.asDriver()
        )

        let output = viewModel.transform(input: input)
        [output.point
            .drive(pointLabel.rx.text),
         output.selectedDate
            .drive(expireDateButton.rx.title()),
         output.datePickerHidden
             .drive(datePicker.rx.isHidden),
         output.saveEnabled
             .drive(saveBarButtonItem.rx.isEnabled),
         output.dismiss
            .drive()].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemBackground

        navigationItem.title = "CreateMssion.Navigation.Title".localized
        navigationItem.rightBarButtonItem = saveBarButtonItem

        // MARK: Add views
        view.addSubview(stackView)
//        view.addSubview(pointLabel)
        expireDateView.addSubview(expireDateButton)

//        rewardView.addSubview(rewardButton)
//        rewardButton.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(5)
//            make.top.bottom.trailing.equalToSuperview()
//        }

        // MARK: Make Constraints
//        pointLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }

        expireDateButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.bottom.trailing.equalToSuperview()
        }

        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        rewardTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        expireDateView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        datePicker.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        descriptionTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }

//        stackView.arrangedSubviews[0].snp.makeConstraints { make in
//            make.height.equalTo(50)
//        }
//
//        stackView.arrangedSubviews[1].snp.makeConstraints { make in
//            make.height.equalTo(50)
//        }
//
//        stackView.arrangedSubviews[2].snp.makeConstraints { make in
//            make.height.equalTo(50)
//        }
//
//        stackView.arrangedSubviews[3].snp.makeConstraints { make in
//            make.height.equalTo(216)
//        }
//
//        stackView.arrangedSubviews[4].snp.makeConstraints { make in
//            make.height.equalTo(50)
//        }
    }
}

// MARK: Previews

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct CreateMissionViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CreateMissionViewController {
        return CreateMissionViewController(viewModel: CreateMissionViewModel(coordinator: HomeCoordinator(navigationController: UINavigationController())))
    }

    func updateUIViewController(_ uiViewController: CreateMissionViewController, context: Context) {
    }
}

@available(iOS 13.0, *)
struct HomeVCPreview: PreviewProvider {
    static var previews: some View {
        Group {
            CreateMissionViewControllerRepresentable()
            CreateMissionViewControllerRepresentable()
        }
    }
}
#endif
