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
    let viewModel: HomeViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView().then { indicator in
        indicator.color = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
    }

//    lazy var dataSource: RxTableViewSectionedReloadDataSource<MissionSection> = {
//        let dataSource = RxTableViewSectionedReloadDataSource<MissionSection>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier(), for: indexPath) as! HomeTableViewCell
//            cell.bind(HomeItemViewModel(with: item)) // 안해줘도 될 듯
//            return cell
//        })
//        return dataSource
//    }()

    lazy var tableView: UITableView = UITableView().then { table in
        // 50 Constant로 빼기
        table.rowHeight = 50
        table.tableFooterView = UIView()
        table.refreshControl = UIRefreshControl()
        // datasource로 하면 다시 생각
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier())
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

        setupUI()
        bindViewModel()
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

        let input = HomeViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                        createMissionTrigger: createBarButtonItem.rx.tap.asDriver(),
                                        selection: tableView.rx.itemSelected.asDriver())

        let output = viewModel.transform(input: input)

        // Bind Missions to UITableView
//        output.missions
//            .drive(tableView.rx.items(dataSource: viewModel.dataSource))
//            .disposed(by: disposeBag)

//        let data = viewModel.dataSource
//        output.missions
//            .drive(tableView.rx.items(dataSource: data))
//            .disposed(by: disposeBag)

        output.missions
            .drive(tableView.rx.items(cellIdentifier: HomeTableViewCell.reuseIdentifier(),
                                      cellType: HomeTableViewCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }
            .disposed(by: disposeBag)

        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)

        output.createMission
            .drive()
            .disposed(by: disposeBag)

        output.selectedMission
            .drive()
            .disposed(by: disposeBag)
    }
}

// MARK: - Set UIs
extension HomeViewController {
    private func setupUI() {
        navigationItem.rightBarButtonItem = createBarButtonItem

        // add subviews
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

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

// extension HomeViewController: UITableViewDelegate {
//     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//         let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
//         let headerView = UIView(frame: frame)
//         headerView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
//
//         switch section {
//         case 0:
//             headerView.addSubview(createMissionButton)
//
//             createMissionButton
//                 .snp
//                 .makeConstraints { make in
//                     make.bottom
//                         .top
//                         .leading
//                         .trailing
//                         .equalToSuperview()
//                 }
//             return headerView
//         case 1:
//             headerView.addSubview(detailMissionButton)
//
//             detailMissionButton
//                 .snp
//                 .makeConstraints { make in
//                     make.bottom
//                         .top
//                         .leading
//                         .trailing
//                         .equalToSuperview()
//                 }
//             return headerView
//         default:
//             return nil
//         }
//     }
//
//     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//         return 40
//     }
// }

// MARK: - Previews

 #if canImport(SwiftUI) && DEBUG
 import SwiftUI
 @available(iOS 13.0, *)
 struct HomeVCRepresentable: UIViewControllerRepresentable {
 func makeUIViewController(context: Context) -> HomeViewController {
 HomeViewController(viewModel: HomeViewModel(coordinator: HomeCoordinator(navigationController: UINavigationController())))
 }

 func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
 }
 }

 @available(iOS 13.0, *)
 struct HomeVCPreview: PreviewProvider {
 static var previews: some View {
 HomeVCRepresentable()
 }
 }
 #endif
