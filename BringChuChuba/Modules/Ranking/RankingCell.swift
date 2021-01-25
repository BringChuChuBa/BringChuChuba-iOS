//
//  RankingCell.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/22.
//

import UIKit
import RxSwift
import RxCocoa

class RankingCell: UITableViewCell {

    private let disposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
    }

    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }

    private lazy var imgView = UIImageView().then {
        $0.backgroundColor = .systemGreen
    }

    private lazy var rankLabel = UILabel().then {
        $0.font = $0.font.withSize(17)
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = $0.font.withSize(17)
    }

    private lazy var detailLabel = UILabel().then {
        $0.font = $0.font.withSize(17)
    }

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Set UIs
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        stackView.addArrangedSubview(rankLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
    }

    // MARK: Binds
    func bind(to viewModel: RankingCellViewModel, rank: Int) {
        rankLabel.text = String(rank)

        viewModel.title.asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.detail.asDriver()
            .drive(detailLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
