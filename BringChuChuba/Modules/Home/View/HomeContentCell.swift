//
//  HomeCollectionViewCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import UIKit
import SnapKit
import Then

final class HomeContentCell: UITableViewCell {
    // MARK: - Properties
    private lazy var titleLabel: UILabel = UILabel().then { label in
        // 속성 변경
        label.textAlignment = .center
    }

    var missions: Mission! {
        didSet {
            displayData()
            setupMission()
        }
    }

    var viewModel: HomeItemViewModel! {
        didSet {
            self.configure()
        }
    }

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
extension HomeContentCell {
    private func configure() {
        self.titleLabel.text = viewModel.title
    }
}

// MARK: - Setup UI
extension HomeContentCell {
    private func setupUI() {
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
}

extension HomeContentCell {
    private func displayData() {
//        userName.text = post.user
//        likes.text = String(post.likes)
//        profileImage.kf.setImage(with: post.getUserImageURL(), placeholder: UIImage(named: "profile"))
//        postImage.kf.setImage(with: post.getImageURL(), placeholder: UIImage(named: "placeholder"))
    }

    private func setupMission() {
//        profileImage.layer.cornerRadius = profileImage.frame.height / 2
//        postImage.layer.cornerRadius = 14
    }
}
