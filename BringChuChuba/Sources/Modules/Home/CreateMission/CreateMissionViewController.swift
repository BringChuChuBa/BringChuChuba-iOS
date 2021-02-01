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
    private lazy var saveBarButtonItem = UIBarButtonItem().then {
        $0.title = "Common.Done".localized
        $0.style = .done
    }

    private lazy var titleTextField = UITextField().then {
        // custom
        $0.placeholder = "Common.Title".localized
        $0.font = .systemFont(ofSize: 13)

        // default
        $0.keyboardType = .default
        $0.returnKeyType = .done
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.clearButtonMode = .whileEditing
        $0.contentVerticalAlignment = .center
        $0.keyboardAppearance = .default
        $0.autocapitalizationType = .none
    }

    private lazy var rewardTextField = UITextField().then {
        // custom
        $0.placeholder = "Common.Reward".localized
        $0.font = .systemFont(ofSize: 13)

        // default
        $0.keyboardType = .default
        $0.returnKeyType = .done
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.clearButtonMode = .whileEditing
        $0.contentVerticalAlignment = .center
        $0.keyboardAppearance = .default
        $0.autocapitalizationType = .none
    }

    private lazy var datePicker = UIDatePicker().then {
        if #available(iOS 14.0, *) {
            $0.preferredDatePickerStyle = .inline
        }
        $0.datePickerMode = .dateAndTime
        $0.locale = .current
        $0.minuteInterval = 30
        $0.date = Date()
        let nextMinuteIntervalDate = Date().rounded(minutes: 30, rounding: .ceil)
        $0.minimumDate = nextMinuteIntervalDate
        $0.timeZone = .current
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // textView로 바꿔야하나
    private lazy var descriptionTextField = UITextField().then {
        // custom
        $0.placeholder = "Common.Description".localized
        $0.font = .systemFont(ofSize: 13)

        // default
        $0.keyboardType = .default
        $0.returnKeyType = .done
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.clearButtonMode = .whileEditing
        $0.contentVerticalAlignment = .center
        $0.keyboardAppearance = .default
        $0.autocapitalizationType = .none
    }

    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }

    // MARK: Initializers
    init(viewModel: CreateMissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
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

        let input = CreateMissionViewModel.Input(
            title: titleTextField.rx.text.orEmpty.asDriver(),
            reward: rewardTextField.rx.text.orEmpty.asDriver(),
            dateSelected: datePicker.rx.date.asDriver(),
            description: descriptionTextField.rx.text.orEmpty.asDriver(),
            saveTrigger: saveBarButtonItem.rx.tap.asDriver()
        )

        let output = viewModel.transform(input: input)
        [output.selectedDate
            .drive(datePicker.rx.value),
         output.saveEnabled
             .drive(saveBarButtonItem.rx.isEnabled),
         output.dismiss
            .drive()].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemBackground

        navigationItem.title = "CreateMission.Navigation.Title".localized
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(stackView)
        [titleTextField,
         rewardTextField,
         datePicker,
         descriptionTextField
        ].forEach { stackView.addArrangedSubview($0) }

        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeArea.edges).inset(20)
        }
    }
}

// MARK: Previews
/*
#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct CreateMissionViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CreateMissionViewController {
    return CreateMissionViewController(
 viewModel: CreateMissionViewModel(
 coordinator: HomeCoordinator(
 navigationController: UINavigationController()
 )
 )
 )
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
*/
