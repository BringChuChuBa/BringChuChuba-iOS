//
//  HomeHeaderCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import UIKit
import SnapKit
import Then

final class HomeHeaderCell: UICollectionViewCell {
    // MARK: - Properties
    private lazy var createMissionButton: UIButton = UIButton(type: .system).then { btn in
        // TODO: 이미지로 대체
        btn.setTitle("create", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(createBtnClicked(_:)), for: .touchUpInside)
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func createBtnClicked(_ sender: UIButton) {
        // post API
    }
}

// MARK: - Setup UI
extension HomeHeaderCell {
    private func setupUI() {
        contentView.addSubview(createMissionButton)

        createMissionButton.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
