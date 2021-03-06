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

class MyMissionViewController: UIViewController {
    // MARK: Properties
    let reloadSubject = PublishSubject<Void>()
    var reloadBinding: Binder<Void> {
        return Binder(self) { base, _ in
            base.reloadSubject.onNext(())
        }
    }
    private let viewModel: MyMissionViewModel!
    private let disposeBag = DisposeBag()
    private let status: Mission.Status
    
    // MARK: UI Components
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(
            MyMissionTableViewCell.self,
            forCellReuseIdentifier: MyMissionTableViewCell.reuseIdentifier()
        )
        $0.rowHeight = 100
        $0.estimatedRowHeight = 100
//        $0.refreshControl = UIRefreshControl()
        $0.allowsSelection = false
        $0.delaysContentTouches = false
    }
    
    // MARK: Initializers
    init(viewModel: MyMissionViewModel, status: Mission.Status) {
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
        
        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
//        let pull = tableView.refreshControl?.rx
//            .controlEvent(.valueChanged)
//            .asDriver()
        
        let relaod = reloadSubject.asDriverOnErrorJustComplete()
        
//        let pullAndReload = Driver.merge(relaod, pull)
        let pullAndReload = relaod
        
        let input = MyMissionViewModel.Input(
            status: status,
            parent: self,
            appear: Driver.merge(viewWillAppear, pullAndReload)
        )
        
        let output = viewModel.transform(input: input)
        
        [
//            output.fetching
//            .drive(tableView.refreshControl!.rx.isRefreshing),
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
        
        navigationItem.title = "DoingMission.Navigation.Title".localized
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: DoingMissionViewController
final class DoingMissionViewController: MyMissionViewController { }
