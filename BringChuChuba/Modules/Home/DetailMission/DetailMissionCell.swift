//
//  DetailMissionCell.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/21.
//

import UIKit

import RxCocoa
import RxSwift

class DetailMissionCell: UITableViewCell {

    // MARK: Properties
    private let disposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
    }

    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = $0.font.withSize(12)
        $0.textColor = .lightGray
    }

    private lazy var detailLabel = UILabel().then {
        $0.font = $0.font.withSize(17)
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
    func bind(to viewModel: DetailMissionCellViewModel) {
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
        backgroundColor = .clear

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
    }
}
