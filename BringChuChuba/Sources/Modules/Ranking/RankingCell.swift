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
    private var disposeBag = DisposeBag()

    // MARK: Constants
    fileprivate struct Constant {
        static let cellPadding: CGFloat = 15
    }
    fileprivate struct Color {
        static let contentViewBackground = UIColor.clear
        static let rankLabelText = UIColor.lightGray
        static let detailLabelText = UIColor(rgb: 0x8E5AF7, a: 0.8)
    }

    fileprivate struct Font {
        static let rankLabel = UIFont.boldSystemFont(ofSize: 17)
        static let titleLabel = UIFont.systemFont(ofSize: 17)
        static let detailLabel = UIFont.boldSystemFont(ofSize: 30)
    }

    // MARK: UI Components
    private lazy var imgView = CircularImageView().then {
        // default
        $0.image = UIImage(systemName: "person.fill")
//        $0.backgroundColor = .darkGray
        $0.tintColor = .systemGray
    }

    private lazy var rankLabel = UILabel().then {
        $0.font = Font.rankLabel
        $0.textColor = Color.rankLabelText
        $0.textAlignment = .center
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = Font.titleLabel
    }

    private lazy var detailLabel = UILabel().then {
        $0.font = Font.detailLabel
        $0.textColor = Color.detailLabelText
    }

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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

        contentView.addSubview(rankLabel)
        contentView.addSubview(imgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)

//        contentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview().inset(20)
//        }

        rankLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(30)
        }

        imgView.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(10)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imgView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

        detailLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
    }
}

class CircularImageView: UIImageView {
    override var frame: CGRect {
        didSet {
            self.layer.cornerRadius = frame.size.width * 0.5
            self.layer.masksToBounds = true
        }
    }
}
