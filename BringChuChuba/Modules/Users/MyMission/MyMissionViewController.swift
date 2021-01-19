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

class MyMissionViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    }
}
