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

final class RankingViewController: UIViewController {
    private enum Period: Int, CaseIterable {
        case all = 0
        case monthly
        case weekly

        var description: String {
            switch self {
            case .all: return "all"
            case .monthly: return "monthly"
            case .weekly: return "weekly"
            }
        }
    }

    // MARK: Properties
    private let viewModel: RankingViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var segmentedControl = UISegmentedControl(
        items: Period.allCases.map { $0.description.capitalized }).then {
            $0.selectedSegmentIndex = 0
        }

    private lazy var tableView = UITableView(frame: CGRect(), style: .plain).then {
        $0.register(RankingCell.self, forCellReuseIdentifier: RankingCell.reuseIdentifier())
        $0.refreshControl = UIRefreshControl()
    }

    // MARK: - Initializers
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

        let input = RankingViewModel.Input(
            selectedIndex: segmentedControl.rx.selectedSegmentIndex.asDriver()
        )

        let output = viewModel.transform(input: input)
        [output.items
            .drive(tableView.rx.items(
                    cellIdentifier: RankingCell.reuseIdentifier(),
                    cellType: RankingCell.self)) { indexPath, viewModel, cell in
                cell.bind(to: viewModel, rank: indexPath + 1)
            }
        ].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemBackground

        navigationItem.title = "Ranking.Navigation.Title".localized

        view.addSubview(segmentedControl)
        view.addSubview(tableView)

        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom)
        }
    }
}
