//
//  DoingMissionTableViewCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import SnapKit
import Then

final class DoingMissionTableViewCell: UITableViewCell {
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
extension DoingMissionTableViewCell {
    func bind(_ viewModel: DoingMissionItemViewModel) {
        self.titleLabel.text = viewModel.title
    }
}

// MARK: - Setup UI
extension DoingMissionTableViewCell {
    private func setupUI() {
//        contentView.addSubview(titleLabel)
//
//        titleLabel.snp.makeConstraints { make in
//            make.width.height.equalToSuperview()
//        }
    }
}
