//
//  DoingMissionTableViewCell.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyMissionTableViewCell: UITableViewCell {
    // MARK: Properties
    private var disposeBag = DisposeBag()
    private var parent: Any?

    // MARK: Constants
    fileprivate struct Color {
        static let deleteButtonTitle = UIColor.white
        static let deleteButtonBackground = UIColor.systemRed
        static let completeButtonTitle = UIColor.white
        static let completeButtonBackground = UIColor.systemGreen
    }

    fileprivate struct Font {
        static let titleLabel = UIFont.boldSystemFont(ofSize: 20)
        static let descriptionLabel = UIFont.systemFont(ofSize: 12)
    }

    // MARK: UI Components
    private lazy var titleLabel = UILabel().then {
        $0.font = Font.titleLabel
    }
    
    private lazy var contractLabel = UILabel().then {
        $0.font = Font.descriptionLabel
    }
    
    private lazy var deleteButton = UIButton(type: .system).then {
        $0.setTitle("Common.Delete".localized, for: .normal)
        $0.setTitleColor(Color.deleteButtonTitle, for: .normal)
        $0.backgroundColor = Color.deleteButtonBackground
    }
    
    private lazy var completeButton = UIButton(type: .system).then {
        $0.setTitle("Common.Complete".localized, for: .normal)
        $0.setTitleColor(Color.completeButtonTitle, for: .normal)
        $0.backgroundColor = Color.completeButtonBackground
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
    func bind(with viewModel: MyMissionCellViewModel, parent: MyMissionViewController) {
        self.parent = parent

        titleLabel.text = viewModel.title
        contractLabel.text = viewModel.mission.contractor?.id
        hideButton(with: viewModel)

        let input = MyMissionCellViewModel.Input(
            deleteTrigger: deleteButton.rx.tap.asDriver(),
            completeTrigger: completeButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)

        [output.deleted
            .drive(parent.reloadBinding),
         output.completed
            .drive(parent.reloadBinding)
        ].forEach { $0.disposed(by: disposeBag) }
    }
    
    // MARK: Set UIs
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(contractLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(completeButton)

//        contentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview().inset(20)
//        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }

        contractLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(20)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(deleteButton.snp.height)
        }

        completeButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(completeButton.snp.height)
        }
    }

    private func hideButton(with viewModel: MyMissionCellViewModel) {
        switch viewModel.status {
        case .todo:
            completeButton.isHidden = true
            deleteButton.isHidden = false
        case .inProgress:
            if parent is DoingMissionViewController {
                completeButton.isHidden = true
                deleteButton.isHidden = true
            } else {
                completeButton.isHidden = false
                deleteButton.isHidden = true
            }
        case .complete:
            completeButton.isHidden = true
            deleteButton.isHidden = true
        }
    }
}
