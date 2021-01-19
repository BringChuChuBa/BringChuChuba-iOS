//
//  DoingMissionTableViewCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import SnapKit
import Then

final class MyMissionTableViewCell: UITableViewCell {
    // MARK: - Properties
    private lazy var titleLabel: UILabel = UILabel().then { label in
        // 속성 변경
        label.textAlignment = .center
    }

    private lazy var descriptionLabel: UILabel = UILabel().then { label in
        // 속성 변경
        label.textAlignment = .center
    }

    private lazy var rewardLabel: UILabel = UILabel().then { label in
        // 속성 변경
        label.textAlignment = .center
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
    func bind(_ viewModel: MyMissionItemViewModel) {
        // title은 나중에 UI로 빼자
        self.titleLabel.text = "title = " + viewModel.title
        self.descriptionLabel.text = "description = " + viewModel.description
        self.rewardLabel.text = "reward = " + viewModel.reward
    }
}

// MARK: - Setup UI
extension MyMissionTableViewCell {
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(rewardLabel)

        titleLabel.snp.makeConstraints { make in
            make.top
                .leading
                .trailing.equalToSuperview()
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
    }
}
