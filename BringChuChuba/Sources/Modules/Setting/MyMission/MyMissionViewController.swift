//
//  DoingMissionViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyMissionViewController: UIViewController {
    // MARK: Properties
    var viewModel: MyMissionViewModel!
    private var status: String
    private let disposeBag = DisposeBag()

    let reloadSubject = PublishSubject<Void>()
    var reloadBinding: Binder<Void> {
        return Binder(self) { base, _ in
            base.reloadSubject.onNext(())
        }
    }
    
    // MARK: UI Components
    private lazy var footerView = UIView(frame: .zero).then {
        $0.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }
    
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        // 50 Constant로 빼기
        $0.contentInsetAdjustmentBehavior = .never
        $0.refreshControl = UIRefreshControl()
        $0.rowHeight = 100
        $0.register(
            MyMissionTableViewCell.self,
            forCellReuseIdentifier: MyMissionTableViewCell.reuseIdentifier()
        )
        $0.allowsSelection = false
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
    
    // MARK: Binds
    private func bindViewModel() {
        assert(viewModel.isSome)
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()

        let relaod = reloadSubject.asDriverOnErrorJustComplete()

        let pullAndReload = Driver.merge(relaod, pull)

        let input = MyMissionViewModel.Input(
            status: status,
            parent: self,
            appear: Driver.merge(viewWillAppear, pullAndReload)
//            appear: viewWillAppear
        )
        
        let output = viewModel.transform(input: input)
        
        [output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing),
         output.missions
            .drive(tableView.rx.items(
                cellIdentifier: MyMissionTableViewCell.reuseIdentifier(),
                cellType: MyMissionTableViewCell.self
            )) { _, viewModel, cell in
                cell.bind(with: viewModel, parent: self)
            },
         output.error
            .drive(errorBinding)
        ].forEach { $0.disposed(by: disposeBag) }
    }
    
    private var errorBinding: Binder<Error> {
        return Binder(self) { _, error in
            print(error.localizedDescription)
        }
    }
    
    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

//        extendedLayoutIncludesOpaqueBars = true

//        navigationItem.title = "DoingMission.Navigation.Title".localized
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeArea.edges)
//            make.top.equalToSuperview()
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
