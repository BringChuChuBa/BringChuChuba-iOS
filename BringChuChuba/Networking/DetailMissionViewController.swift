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

final class DetailMissionViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: DetailMissionViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Initializers
    init(viewModel: DetailMissionViewModel) {
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
extension DetailMissionViewController {
    private func bindViewModel() {
        assert(viewModel.isSome)
//
//        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
//            .mapToVoid()
//            .asDriverOnErrorJustComplete()
//
//        let input = CreateMissionViewModel.Input(
//            appear: viewWillAppear,
//            title: titleTextField.rx.text.orEmpty.asDriver(),
//            description: descriptionTextField.rx.text.orEmpty.asDriver(),
//            reward: rewardButton.rx.tap.asDriver(),
//            expireDate: expireDateButton.rx.tap.asDriver(), // expireDateTextField.rx.text.orEmpty.asDriver(),
//            saveTrigger: saveBarButtonItem.rx.tap.asDriver()
//        )
//
//        let output = viewModel.transform(input: input)
//
//        output.point
//            .drive(pointLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        output.toReward
//            .drive()
//            .disposed(by: disposeBag)
//
//        output.test
//            .drive()
//            .disposed(by: disposeBag)
//
//        output.showPicker
//            .drive(expireDateButton.rx.title(for: .normal))
//            .disposed(by: disposeBag)
//
//        output.saveEnabled
//            .drive(saveBarButtonItem.rx.isEnabled)
//            .disposed(by: disposeBag)
    }
}

// MARK: - Set UIs
extension DetailMissionViewController {
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    }
}
