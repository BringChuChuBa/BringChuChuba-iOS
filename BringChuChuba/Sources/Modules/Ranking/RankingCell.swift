//
//  RankingCell.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/22.
//

import UIKit

import RxCocoa
import RxSwift

class RankingCell: UITableViewCell {
    // MARK: Properties
    private let disposeBag = DisposeBag()

    // MARK: Constants
    fileprivate struct Color {
        static let contentViewBackground = UIColor.clear
    }

    fileprivate struct Font {
        static let rankLabel = UIFont.boldSystemFont(ofSize: 25)
        static let titleLabel = UIFont.systemFont(ofSize: 17)
        static let detailLabel = UIFont.systemFont(ofSize: 17)
    }

    // MARK: UI Components
    private lazy var containerView = UIView().then {
        $0.backgroundColor = Color.contentViewBackground
    }

    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }

    private lazy var imgView = UIImageView().then {
        // default
        $0.image = UIImage(systemName: "person.fill")
        $0.tintColor = .systemGray
    }

    private lazy var rankLabel = UILabel().then {
        $0.font = Font.rankLabel
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = Font.titleLabel
    }

    private lazy var detailLabel = UILabel().then {
        $0.font = Font.detailLabel
    }

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    // MARK: Set UIs
    func setupUI() {
        selectionStyle = .none

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        stackView.addArrangedSubview(imgView)
        stackView.addArrangedSubview(rankLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)

        imgView.snp.makeConstraints { make in
            make.width.equalTo(imgView.snp.height)
        }
    }
}
