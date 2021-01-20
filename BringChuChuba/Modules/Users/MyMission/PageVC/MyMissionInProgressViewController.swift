//
//  MyMissionInProgressViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/20.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MyMissionInProgressViewController: UIViewController {
    // MARK: - Properties
    var viewModel: MyMissionViewModel!
    private let disposeBag = DisposeBag()

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
    }
}

// MARK: - Binds
extension MyMissionInProgressViewController {
    func bindViewModel() {
        assert(viewModel.isSome)
    }
}

// MARK: - Set UIs
extension MyMissionInProgressViewController {
    func setupUI() {
    }
}
