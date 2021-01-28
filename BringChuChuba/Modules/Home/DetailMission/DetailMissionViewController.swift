//
//  DetailMissionViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

final class DetailMissionViewController: UIViewController {
    // MARK: Properties
    private let viewModel: DetailMissionViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var tableView = UITableView(frame: CGRect(), style: .insetGrouped).then {
        // TODO: refresh, alert 추가하기
        $0.register(DetailMissionCell.self,
                    forCellReuseIdentifier: DetailMissionCell.reuseIdentifier())
    }

    private lazy var toolBar = UIToolbar().then {
        $0.barStyle = .default
        $0.isTranslucent = true
        $0.setItems([leftSpace, contractButton, rightSpace], animated: true)
    }

    private lazy var leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                 target: nil,
                                                 action: nil)

    private lazy var rightSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                  target: nil,
                                                  action: nil)

    private lazy var contractButton = UIBarButtonItem().then {
        $0.title = "DetailMission.ContractButton.Title".localized
    }

    // MARK: Initializers
    init(viewModel: DetailMissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
    }

    // MARK: Binds
    private func bindViewModel() {
        assert(viewModel.isSome)

        let input = DetailMissionViewModel.Input(contractTrigger: contractButton.rx.tap.asDriver())

        let dataSource = RxTableViewSectionedReloadDataSource<DetailMissionSection>(
            configureCell: { _, tableView, indexPath, item in
                switch item {
                case .titleItem(let viewModel),
                     .descriptionItem(let viewModel),
                     .rewardItem(let viewModel),
                     .expireAtItem(let viewModel),
                     .clientItem(let viewModel),
                     .contractorItem(let viewModel),
                     .statusItem(let viewModel):
                    guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: DetailMissionCell.reuseIdentifier(),
                            for: indexPath) as? DetailMissionCell else { fatalError() }
                    cell.bind(to: viewModel)
                    return cell
                }},
            titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
            }
        )

        let output = viewModel.transform(input: input)

        [output.items
            .drive(tableView.rx.items(dataSource: dataSource)),
         output.contractEnable
            .drive(contractButton.rx.isEnabled),
         output.error
            .drive()].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemBackground

        navigationItem.title = "DetailMission.Navigation.Title".localized

        view.addSubview(toolBar)
        view.addSubview(tableView)

        toolBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(toolBar.snp.top)
        }

        contractButton.setBackgroundVerticalPositionAdjustment(20.0, for: .default)
    }
}
