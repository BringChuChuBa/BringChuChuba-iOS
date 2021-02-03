//
//  RankingViewController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

enum RankingSegments: Int, CaseIterable {
    case all
    case monthly

    var title: String {
        switch self {
        case .all: return "전체"
        default: return "이번달"
        }
    }
}

final class RankingViewController: UIViewController {
    // MARK: Properties
    private let viewModel: RankingViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var segmentedControl = UISegmentedControl(
        items: RankingSegments.allCases.map { $0.title }
    ).then {
        $0.selectedSegmentIndex = 0
    }

    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(RankingCell.self, forCellReuseIdentifier: RankingCell.reuseIdentifier())
        $0.rowHeight = 80
        $0.refreshControl = UIRefreshControl()
    }

    // MARK: Initializers
    init(viewModel: RankingViewModel) {
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

        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()

        let input = RankingViewModel.Input(
            trigger: Driver.merge(viewWillAppear, pull),
            segmentedSelected: segmentedControl.rx.selectedSegmentIndex
                .map { RankingSegments(rawValue: $0)! }
                    .asDriverOnErrorJustComplete()
        )

        let output = viewModel.transform(input: input)
        [output.items
            .drive(tableView.rx.items(
                    cellIdentifier: RankingCell.reuseIdentifier(),
                    cellType: RankingCell.self)
            ) { indexPath, viewModel, cell in
                cell.bind(to: viewModel, rank: indexPath + 1)
            },
         output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
        ].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        navigationItem.title = "Ranking.Navigation.Title".localized

        view.addSubview(segmentedControl)
        view.addSubview(tableView)

        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.equalTo(view.safeArea.top)
            //            make.top.equalToSuperview().inset(safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom)
            make.bottom.equalTo(view.safeArea.bottom)
        }
    }
}
