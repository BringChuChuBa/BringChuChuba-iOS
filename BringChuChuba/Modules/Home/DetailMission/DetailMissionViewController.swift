//
//  DetailMissionViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/11.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class DetailMissionViewController: UIViewController {

    // MARK: Properties
    private let viewModel: DetailMissionViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var tableView = UITableView(frame: CGRect(), style: .insetGrouped).then {
        // TODO: refresh, alert 추가하기
        $0.register(DetailMissionCell.self, forCellReuseIdentifier: "DetailMissionCell")
    }

    private lazy var toolBar = UIToolbar().then {
        $0.barStyle = .default
        $0.isTranslucent = true
    }

    private lazy var contractButton = UIBarButtonItem().then {
        $0.title = "제가 할게요!"
        // TODO: 밑에서 띄우는거...
        // TODO: 백그라운드 컬러 변경 -> extension ??
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

        setupUI()
        bindViewModel()
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }

        view.addSubview(toolBar)

        // TODO: 프로퍼티 밖으로 빼야할지..?
        let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightflexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([leftFlexibleSpace,
                          contractButton,
                          rightflexibleSpace],
                         animated: true)

        toolBar.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.trailing.bottom.equalToSuperview().inset(additionalSafeAreaInsets)
        }
    }

    // MARK: Binds
    private func bindViewModel() {
        assert(viewModel.isSome)

        let input = DetailMissionViewModel.Input(
            contractTrigger: contractButton.rx.tap.asDriver()
        )

        let dataSource = RxTableViewSectionedReloadDataSource<DetailMissionSection>(configureCell: { _, tableView, indexPath, item in
            switch item {
            case .titleItem(let viewModel),
                 .descriptionItem(let viewModel),
                 .rewardItem(let viewModel),
                 .expireAtItem(let viewModel),
                 .clientItem(let viewModel),
                 .contractorItem(let viewModel),
                 .statusItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "DetailMissionCell", for: indexPath) as? DetailMissionCell)!
                cell.bind(to: viewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })

        let output = viewModel.transform(input: input)

        [output.items
            .bind(to: tableView.rx.items(dataSource: dataSource)),
         output.contractEnable
            .drive(contractButton.rx.isEnabled),
         output.error
            .drive()
        ].forEach { $0.disposed(by: disposeBag) }
    }
}
