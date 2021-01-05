//
//  UsersViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit

class UsersViewController: UIViewController {
    var viewModel: UsersViewModel!

    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    }
}
