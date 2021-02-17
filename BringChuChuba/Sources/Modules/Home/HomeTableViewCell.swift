//
//  HomeCollectionViewCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeTableViewCell: UITableViewCell {
    private var disposeBag: DisposeBag = DisposeBag()
    private var parent: HomeViewController?

    // MARK: Constants
    fileprivate struct Color {
        static let clientLabelBackground = UIColor(
            red: 0.267,
            green: 0.267,
            blue: 0.267,
            alpha: 1
        ).cgColor
        static let expireAtLabelText = UIColor.gray
        static let rewardViewBackground = UIColor(
            red: 0.973,
            green: 0.973,
            blue: 0.973,
            alpha: 1
        ).cgColor
        static let commonBorder = UIColor(
            red: 0.867,
            green: 0.867,
            blue: 0.867,
            alpha: 1
        ).cgColor

        static let commonPurple = UIColor(rgb: 0x8E5AF7, a: 0.8)
    }

    fileprivate struct Font {
        static let clientLabel = UIFont.systemFont(ofSize: 12)
        static let titleLabel = UIFont.boldSystemFont(ofSize: 20)
        static let expireAtLabel = UIFont.systemFont(ofSize: 11)
        static let statusLabel = UIFont.systemFont(ofSize: 12)
        static let rewardTitleLabel = UIFont.boldSystemFont(ofSize: 14)
        static let rewardLabel = UIFont.systemFont(ofSize: 12)
        static let contractButton = UIFont.boldSystemFont(ofSize: 14)
    }

    // MARK: UIs
    private lazy var clientLabel = PaddingLabel().then {
        $0.font = Font.clientLabel
        $0.textColor = .white
        $0.padding(4, 4, 6, 6)
        $0.layer.backgroundColor = Color.clientLabelBackground
        $0.layer.cornerRadius = 4
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
    }

    private lazy var expireAtLabel = UILabel().then {
        $0.font = Font.expireAtLabel
        $0.textColor = .gray
    }

    private lazy var statusLabel = UILabel().then {
        $0.font = Font.statusLabel
    }

    private lazy var progressBar = UIProgressView().then {
        $0.progressTintColor = Color.commonPurple
        $0.trackTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        $0.progress = 1
    }

    private lazy var rewardView = UIView().then {
        $0.layer.backgroundColor = Color.rewardViewBackground
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Color.commonBorder
    }

    private lazy var rewardTitleLabel = UILabel().then {
        $0.text = "미션 수행시 보상"
        $0.font = Font.rewardTitleLabel
    }

    private lazy var rewardLabel = UILabel().then {
        $0.font = Font.rewardLabel
        $0.numberOfLines = 0
    }

    private lazy var contractButton = UIButton().then {
        $0.setTitle("DetailMission.ContractButton.Title".localized, for: .normal)
        $0.setBackgroundColor(Color.commonPurple, for: .normal)
        $0.setBackgroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .disabled)
        $0.titleLabel?.font = Font.contractButton
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Color.commonBorder
        $0.clipsToBounds = true
    }

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame
            .inset(by: UIEdgeInsets(
                    top: 20,
                    left: 20,
                    bottom: 0,
                    right: 20)
            )
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    // MARK: Binds
    func bind(with viewModel: HomeItemViewModel,
              parent: HomeViewController) {
        self.parent = parent

        clientLabel.text = viewModel.mission.client.id + "(이)가 생성함" // ~가, ~이가
        titleLabel.text = viewModel.mission.title
        expireAtLabel.text = viewModel.mission.expireAt
        statusLabel.text = viewModel.mission.status.title
        progressBar.progress = getTimeProgress(with: viewModel)
        rewardLabel.text = viewModel.mission.reward
        contractButton.isEnabled = checkEnability(with: viewModel)

        let trigger = contractButton.rx.tap
            .asDriverOnErrorJustComplete()

        let input = HomeItemViewModel.Input(contractTrigger: trigger)

        let output = viewModel.transform(input: input)

        [output.contracted
            .drive(parent.reloadBinding),
         output.contractable
            .drive(contractButton.rx.isEnabled)
        ]
        .forEach { $0.disposed(by: disposeBag)}
    }

    // MARK: Progress Bar
    private func getTimeProgress(with viewModel: HomeItemViewModel) -> Float {
        if viewModel.mission.status == .complete {
            return 1.0
        }

        let create: Date = viewModel.mission.createdAt.toDate
        let expire: Date = viewModel.mission.expireAt.toDate
        let now: Date = Date()

        let totalInterval: TimeInterval = expire.timeIntervalSince(create)
        let nowInterval: TimeInterval = now.timeIntervalSince(create)

        let result: Float = Float(nowInterval / totalInterval)

        return result > 1.0 ? 1.0 : result
    }

    private func checkEnability(with viewModel: HomeItemViewModel) -> Bool {
        var contractable: Bool = false
        if viewModel.mission.client.id != GlobalData.shared.id,
           viewModel.mission.status == .todo,
           viewModel.mission.expireAt.toDate.isFuture,
           viewModel.mission.contractor.isNone {
            contractable = true
        }

        return contractable
    }

    // MARK: Set UIs
    private func setupUI() {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 0.92).cgColor

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8

        // add view
        contentView.addSubview(clientLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(expireAtLabel)
        contentView.addSubview(progressBar)

        contentView.addSubview(rewardView)
        rewardView.addSubview(rewardTitleLabel)
        rewardView.addSubview(rewardLabel)

        contentView.addSubview(contractButton)

        // client
        clientLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
        }

        // title
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(clientLabel.snp.bottom).offset(8)
        }

        // expireAt
        expireAtLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(expireAtLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        rewardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(progressBar.snp.bottom).offset(20)
            make.height.equalTo(100)
        }

        rewardTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(12)
        }

        rewardLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(rewardTitleLabel.snp.bottom).offset(8)
        }

        contractButton.snp.makeConstraints { make in
            make.top.equalTo(rewardView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(rewardView).multipliedBy(0.4)
        }
    }
}
