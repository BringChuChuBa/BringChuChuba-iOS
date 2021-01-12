//
//  ExpireViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/12.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class RewardViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: CreateMissionViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Initializers
    init(viewModel: CreateMissionViewModel) {
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
}

// MARK: - Binds
extension RewardViewController {
    private func bindViewModel() {
        assert(viewModel.isSome)

    }
}

// MARK: - Set UIs
extension RewardViewController {
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    }
}
