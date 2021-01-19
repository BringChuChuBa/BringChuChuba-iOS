//
//  DoingMissionViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MyMissionViewController: UIViewController {
    // MARK: - Properties
    var viewModel: MyMissionViewModel!
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = UITableView().then { table in
        // 50 Constant로 빼기
        table.rowHeight = 100
        table.refreshControl = UIRefreshControl()
        table.register(MyMissionTableViewCell.self,
                       forCellReuseIdentifier: MyMissionTableViewCell.reuseIdentifier())
    }

    // MARK: - Initializers
    init(viewModel: MyMissionViewModel) {
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
        view.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
    }
}

// MARK: - Binds
extension MyMissionViewController {
    func bindViewModel() {
        assert(viewModel.isSome)

        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let input = MyMissionViewModel.Input(appear: viewWillAppear)

        let output = viewModel.transform(input: input)

        [output.missions
             .drive(tableView.rx.items(
                     cellIdentifier: MyMissionTableViewCell.reuseIdentifier(),
                     cellType: MyMissionTableViewCell.self)
             ) { _, viewModel, cell in
                 cell.bind(viewModel)
             }
        ].forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - Set UIs
extension MyMissionViewController {
    func setupUI() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top
                .bottom
                .leading
                .trailing
                .equalToSuperview()
        }
    }
}
