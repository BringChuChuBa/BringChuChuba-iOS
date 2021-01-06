//
//  HomeCollectionViewCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import UIKit
import SnapKit
import Then

final class HomeCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private lazy var roundedView: UIView = UIView().then { view in
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 5
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension HomeCollectionViewCell {
    private func setupUI() {
        contentView.addSubview(roundedView)

        roundedView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
