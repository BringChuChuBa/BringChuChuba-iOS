// //
// //  BaseViewController.swift
// //  BringChuChuba
// //
// //  Created by 한상진 on 2021/01/20.
// //
//
// import UIKit
// import RxSwift
// import RxCocoa
// import SnapKit
// import Then
//
// final class BaseViewController: UIViewController {
//     // MARK: - Properties
//     var viewModel:
//     private let disposeBag = DisposeBag()
//
//     // MARK: - Initializers
//     init(viewModel: ) {
//         self.viewModel = viewModel
//         super.init(nibName: nil, bundle: nil)
//     }
//
//     required init?(coder: NSCoder) {
//         fatalError("init(coder:) has not been implemented")
//     }
//
//     // MARK: - LifeCycles
//     override func viewDidLoad() {
//         super.viewDidLoad()
//
//         bindViewModel()
//         setupUI()
//         view.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
//     }
// }
//
// // MARK: - Binds
// extension ViewController {
//     func bindViewModel() {
//         assert(viewModel.isSome)
//     }
// }
//
// // MARK: - Set UIs
// extension ViewController {
//     func setupUI() {
//     }
// }
