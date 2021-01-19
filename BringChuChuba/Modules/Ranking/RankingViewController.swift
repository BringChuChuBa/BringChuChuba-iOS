//
//  RankingViewController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class RankingViewController: UIViewController {
    var viewModel: RankingViewModel!

    init(viewModel: RankingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    }
}
