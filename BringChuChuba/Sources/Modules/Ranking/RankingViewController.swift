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

enum Periods: Int, CaseIterable {
    case all
    case monthly

    var description: String {
        switch self {
        case .all: return "전체"
        default: return "이번달"
        }
    }
}

final class RankingViewController: UIViewController {
    // MARK: Properties
    private let viewModel: RankingViewModel!
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()

    // MARK: UI Components
    private lazy var segmentedControl = UISegmentedControl(
        items: Periods.allCases.map { $0.description }
    ).then {
        $0.selectedSegmentIndex = 0
        $0.autoresizingMask = .flexibleWidth
        navigationItem.titleView = $0
    }

    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(RankingCell.self, forCellReuseIdentifier: RankingCell.reuseIdentifier())
        $0.rowHeight = 80
//        $0.refreshControl = refreshControl
    }

    private var refreshControlFecting: Binder<Bool> {
        return Binder(refreshControl) { refreshControl, value in
            value ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
        }
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

        let pull = refreshControl.rx
            .controlEvent(.valueChanged)
//            .controlEvent(.primaryActionTriggered)
//            .debug()
//            .map { [refreshControl] in
//                return refreshControl.isRefreshing
//            }
//            .distinctUntilChanged()
//            .filter { $0 == true }
//            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
//            .delay(.seconds(1), scheduler: MainScheduler.instance)
//            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
//            .asDriver()

        let input = RankingViewModel.Input(
            trigger: Driver.merge(viewWillAppear, pull),
            segmentSelected: segmentedControl.rx.selectedSegmentIndex
                .map { Periods(rawValue: $0)! }
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
            .drive(refreshControl.rx.isRefreshing)
        ].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        navigationItem.title = "Ranking.Navigation.Title".localized

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
