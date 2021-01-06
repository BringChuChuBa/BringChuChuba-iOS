//
//  HomeViewController.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class HomeViewController: UIViewController {
    // MARK: - Properties
    let viewModel: HomeViewModel

    lazy var missionCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout())
        .then { collection in
            collection.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            collection.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier())
            collection.dataSource = self
        }

    private let cellWidthHeightConstant: CGFloat = 100
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Initialization
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

        bindView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setConstraints()
        // set title
    }
}

// MARK: - Binds
extension HomeViewController {
    // 필요한지 모르겠음
    private func bindView() {

    }

    private func bindViewModel() {

    }
}

// MARK: - Set UIs
extension HomeViewController {
    private func setupUI() {
        // add subviews
        view.addSubview(missionCollectionView)
    }

    private func setConstraints() {
        missionCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    // TODO: Diffable DataSource로 변경
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let numberOfCells = floor(view.frame.size.width / cellWidthHeightConstant)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidthHeightConstant)) / (numberOfCells + 1)

        print(edgeInsets)

        layout.itemSize = CGSize(
            width: cellWidthHeightConstant,
            height: cellWidthHeightConstant)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: edgeInsets,
            bottom: 0,
            right: edgeInsets)

        return layout
    }
}

// TODO: RxDataSource로 변경
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = HomeCollectionViewCell.reuseIdentifier()

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
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
