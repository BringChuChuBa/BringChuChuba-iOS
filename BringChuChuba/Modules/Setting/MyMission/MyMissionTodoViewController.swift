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

class MyMissionTodoViewController: UIViewController {
    // MARK: Properties
    var viewModel: MyMissionViewModel!
    private let status: String
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = UITableView().then { table in
        // 50 Constant로 빼기
        table.rowHeight = 100
        table.register(MyMissionTableViewCell.self,
                       forCellReuseIdentifier: MyMissionTableViewCell.reuseIdentifier())
    }

    // MARK: Initializers
    init(viewModel: MyMissionViewModel, status: String) {
        self.viewModel = viewModel
        self.status = status
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
}

// MARK: Binds
extension MyMissionTodoViewController {
    func bindViewModel() {
        assert(viewModel.isSome)

        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let input = MyMissionViewModel.Input(status: status,
                                             appear: viewWillAppear)

        let output = viewModel.transform(input: input)

        [output.missions
             .drive(tableView.rx.items(
                     cellIdentifier: MyMissionTableViewCell.reuseIdentifier(),
                     cellType: MyMissionTableViewCell.self)
             ) { _, viewModel, cell in
                cell.bind(with: viewModel)
             }
        ].forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: Set UIs
extension MyMissionTodoViewController {
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
