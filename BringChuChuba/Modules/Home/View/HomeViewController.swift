//
//  HomeViewController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: UIViewController {
    // MARK: - Properties
    let viewModel: HomeViewModel
    private let disposeBag: DisposeBag = DisposeBag()
    private var activityIndicator: UIActivityIndicatorView!

    var homeTableView: UITableView = UITableView().then { table in
        // TODO: 50 Constant로 빼기
        table.rowHeight = 50
        table.tableFooterView = UIView()
    }

    // MARK: - Initializers
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator = UIActivityIndicatorView()
        setup(activityIndicator: activityIndicator)

        bindView()
        bindViewModel()

        // 여기에 추가하는게 맞는지 고민
        homeTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setConstraints()
        // set title
    }

    // MARK: - Methods
    // coordinator 이동
//    private func goToProfileScreen(for post: Post) {
//        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        profileVC.post = post
//        present(profileVC, animated: true, completion: nil)
//    }

    private func updateUI(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.activityIndicator.startAnimating()
                self.homeTableView.isHidden = true
            } else {
                self.activityIndicator.stopAnimating()
                self.homeTableView.isHidden = false
            }
        }
    }

    private func setup(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.color = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
}

// MARK: - Binds
extension HomeViewController {
    // 필요한지 모르겠음
    private func bindView() {

    }

    private func bindViewModel() {
        // 맞는지 모름
        viewModel.items
            .bind(to: homeTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)

//        viewModel
//            .missions
//            .observe(on: MainScheduler.instance)
//            .bind(to: homeTableView.rx.items(cellIdentifier: HomeContentCell.reuseIdentifier(), cellType: HomeContentCell.self)
//            .disposed(by: disposeBag)

        homeTableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.homeTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        homeTableView.rx.modelSelected(Mission.self)
            .subscribe(onNext: { _ in // [unowned self] mission in
                // coordinator가 modal로 push
//                self.goToMissionDetail(for: mission)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Set UIs
extension HomeViewController {
    private func setupUI() {
        // add subviews
        view.addSubview(homeTableView)
    }

    private func setConstraints() {
        homeTableView.snp.makeConstraints { make in
            make.top
                .bottom
                .leading
                .trailing
                .equalToSuperview()
        }
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)

        let button: UIButton = UIButton(type: .system)

        switch section {
        case 0:
            button.setTitle("create", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            headerView.addSubview(button)

            button.snp.makeConstraints { make in
                make.bottom
                    .top
                    .leading
                    .trailing
                    .equalToSuperview()
            }
            return headerView
        case 1:
            button.setTitle("list", for: .normal)
            return headerView
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - Previews
/*
 #if canImport(SwiftUI) && DEBUG

 import SwiftUI

 struct HomeVCRepresentable: UIViewControllerRepresentable {
     func makeUIViewController(context: Context) -> HomeViewController {
        HomeViewController(viewModel: HomeViewModel(coordinator: HomeCoordinator(navigationController: UINavigationController())))
     }

     func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
     }
 }

 struct HomeVCPreview: PreviewProvider {
     static var previews: some View {
        HomeVCRepresentable()
     }
 }

 #endif
*/
