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

class DoingMissionViewController: UIViewController {
    // MARK: - Properties
    var viewModel: DoingMissionViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Initializers
    init(viewModel: DoingMissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
    }
}
