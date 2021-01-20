//
//  HomeViewController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    // MARK: - Properties
    var viewModel: HomeViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView().then { indicator in
        // color constants로 뺴기
        indicator.color = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
    }

    private lazy var tableView: UITableView = UITableView().then { table in
        // 50 Constant로 빼기
        table.rowHeight = 50
        table.refreshControl = UIRefreshControl()
        table.register(
            HomeTableViewCell.self,
            forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier()
        )
    }

    private lazy var createBarButtonItem: UIBarButtonItem = UIBarButtonItem().then { button in
        button.title = "create" // 추후 이미지로 교체
        button.style = .done
    }

    private lazy var detailMissionButton: UIButton = UIButton(type: .system).then { button in
        button.setTitle("detail", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
    }

    // MARK: - Initializers
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
    }

    // MARK: - Methods
}

// MARK: - Binds
extension HomeViewController {
    private func bindViewModel() {
        assert(viewModel.isSome)

        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()

        let input = HomeViewModel.Input(
            trigger: Driver.merge(viewWillAppear, pull),
            createMissionTrigger: createBarButtonItem.rx.tap.asDriver(),
            selection: tableView.rx.itemSelected.asDriver()
        )

        let output = viewModel.transform(input: input)

        [output.missions
            .drive(tableView.rx.items(
                    cellIdentifier: HomeTableViewCell.reuseIdentifier(),
                    cellType: HomeTableViewCell.self)
            ) { _, viewModel, cell in
                cell.bind(with: viewModel)
            },
         output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing),
         output.createMission
            .drive(),
         output.selectedMission
            .drive()
        ].forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - Set UIs
extension HomeViewController {
    private func setupUI() {
        navigationItem.rightBarButtonItem = createBarButtonItem

        // add subviews
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        // set constraints
        tableView.snp.makeConstraints { make in
            make.top
                .bottom
                .leading
                .trailing
                .equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Previews

// #if canImport(SwiftUI) && DEBUG
// import SwiftUI
// @available(iOS 13.0, *)
// struct HomeVCRepresentable: UIViewControllerRepresentable {
// func makeUIViewController(context: Context) -> HomeViewController {
// HomeViewController(viewModel: HomeViewModel(coordinator: HomeCoordinator(navigationController: UINavigationController())))
// }
//
// func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
// }
// }
//
// @available(iOS 13.0, *)
// struct HomeVCPreview: PreviewProvider {
// static var previews: some View {
// HomeVCRepresentable()
// }
// }
// #endif
