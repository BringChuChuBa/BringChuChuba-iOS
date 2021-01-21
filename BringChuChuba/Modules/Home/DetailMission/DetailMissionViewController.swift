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

    // MARK: Properties
    private let viewModel: DetailMissionViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }

    private lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private lazy var rewardLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private lazy var expiredDateLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private lazy var clientLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private lazy var contractorLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private lazy var statusLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private lazy var contractButton = UIButton(type: .system).then {
        $0.setTitle("제가 할게요!", for: .normal)
    }

    // MARK: Initializers
    init(viewModel: DetailMissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }

        [titleLabel,
        rewardLabel,
        expiredDateLabel,
        descriptionLabel,
        clientLabel,
        contractorLabel,
        statusLabel,
        contractButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    // MARK: Binds
    private func bindViewModel() {
        assert(viewModel.isSome)

        let input = DetailMissionViewModel.Input(
            contractTrigger: contractButton.rx.tap.asDriver()
        )

        let output = viewModel.transform(input: input)

        [output.mission
            .drive(missionBinding),
         output.contractEnable
            .drive(contractButton.rx.isEnabled),
         output.error
            .drive()
        ].forEach { $0.disposed(by: disposeBag) }
    }

    var missionBinding: Binder<Mission> {
        return Binder(self) { vc, mission in
            vc.titleLabel.text = mission.title
            vc.rewardLabel.text = mission.reward
            vc.expiredDateLabel.text = mission.expireAt
            vc.descriptionLabel.text = mission.description
            vc.clientLabel.text = mission.client.id // mission.client.nickname 수정
            vc.contractorLabel.text = mission.contractor?.id ?? "미션중인 사람 없음"
            vc.statusLabel.text = mission.status
        }
    }
}
