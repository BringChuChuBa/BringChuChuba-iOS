//
//  DoingMissionTableViewCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MyMissionTableViewCell: UITableViewCell {
    // MARK: - Properties
    private let disposeBag = DisposeBag()

    private lazy var titleLabel: UILabel = UILabel().then { label in
        // 속성 변경
        label.textAlignment = .left
    }

    private lazy var descriptionLabel: UILabel = UILabel().then { label in
        // 속성 변경
        label.textAlignment = .left
    }

    private lazy var rewardLabel: UILabel = UILabel().then { label in
        // 속성 변경
        label.textAlignment = .left
    }

    private lazy var deleteButton: UIButton = UIButton(type: .system).then { button in
        button.setTitle("delete", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
    }

    private lazy var completeButton: UIButton = UIButton(type: .system).then { button in
        button.setTitle("complete", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
    }

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Binding
extension MyMissionTableViewCell {
    func bind(with viewModel: MyMissionItemViewModel) {
        self.titleLabel.text = "title = " + viewModel.title
        self.descriptionLabel.text = "description = " + viewModel.description
        self.rewardLabel.text = "reward = " + viewModel.reward

        let input = MyMissionItemViewModel.Input(deleteTrigger: self.deleteButton.rx.tap.asDriver(),
                                                 completeTrigger: self.completeButton.rx.tap.asDriver())

        let output = viewModel.transform(input: input)

        [output.deleted
            .drive(),
         output.completed
            .drive()
        ].forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - Setup UI
extension MyMissionTableViewCell {
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(rewardLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(completeButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.leading.trailing.equalTo(titleLabel)
        }

        rewardLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.leading.trailing.equalTo(titleLabel)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.height.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-10)
        }

        completeButton.snp.makeConstraints { make in
            make.top.equalTo(rewardLabel)
            make.height.trailing.equalTo(deleteButton)
        }
    }
}
