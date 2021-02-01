//
//  HomeCollectionViewCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/06.
//

import UIKit

import SnapKit
import Then

final class HomeTableViewCell: UITableViewCell {
    // MARK: Properties
    private lazy var titleLabel: UILabel = UILabel().then { label in
        // 속성 변경
        label.textAlignment = .center
    }
    // UIImage 등등 Cell에 그려질 내용 추가
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Binds
    func bind(with viewModel: HomeItemViewModel) {
        self.titleLabel.text = viewModel.title
    }
    
    // MARK: Set UIs
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
}
