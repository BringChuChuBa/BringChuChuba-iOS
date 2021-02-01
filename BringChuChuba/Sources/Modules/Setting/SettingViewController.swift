//
//  UsersViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SettingViewController: UIViewController {
    // MARK: Properties
    private let viewModel: SettingViewModel!
    private let disposeBag = DisposeBag()

    // MARK: UI Components
    // profiles
    private lazy var profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private lazy var nameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .firstBaseline
        $0.distribution = .fillEqually
    }

    private lazy var profileImage = UIImageView().then {
        // TODO: 서버에서 프로필 사진 받아와서 연결
        $0.image = UIImage(named: "profile")
    }

    private lazy var nicknameLabel = UILabel().then {
        $0.text = GlobalData.shared.nickname
    }

    private lazy var idLabel = UILabel().then {
        $0.text = GlobalData.shared.id
    }

    // buttons
    private lazy var myMissionButton = UIButton(type: .system).then {
        $0.setTitle("myMission", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        //        $0.layer.borderWidth = 0.5
        //        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    private lazy var doingMissionButton = UIButton(type: .system).then {
        $0.setTitle("doingMission", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }

    private lazy var inviteMissionButton = UIButton(type: .system).then {
        $0.setTitle("inviteMission", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }

    // MARK: Initializers
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
    }

    // MARK: Binds
    private func bindViewModel() {
        assert(viewModel.isSome)

        let input = SettingViewModel.Input(
            photoTrigger: profileImage.rx.tap().asDriverOnErrorJustComplete(),
            myMissionTrigger: myMissionButton.rx.tap.asDriver(),
            doingMissionTrigger: doingMissionButton.rx.tap.asDriver(),
            inviteFamilyTrigger: inviteMissionButton.rx.tap.asDriver()
        )

        let output = viewModel.transform(input: input)
        [output.myMission
            .drive(),
         output.doingMission
            .drive(),
         output.profile
            .drive(),
         output.invite
            .drive()
        ].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        navigationItem.title = "Setting.Navigation.Title".localized

        // add subviews
        view.addSubview(profileStackView)

        profileStackView.addArrangedSubview(profileImage)
        profileStackView.addArrangedSubview(nameStackView)

        nameStackView.addArrangedSubview(nicknameLabel)
        nameStackView.addArrangedSubview(idLabel)

        view.addSubview(myMissionButton)
        view.addSubview(doingMissionButton)
        view.addSubview(inviteMissionButton)

        // set constraints

        // profiles
        profileStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(100)
        }

        profileImage.snp.makeConstraints { make in
            make.height.equalTo(profileImage.snp.width)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.width.equalTo(idLabel.snp.width)
        }

        // buttons
        myMissionButton.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom).offset(50)
            make.leading.equalTo(profileStackView)
            make.trailing.equalTo(view.snp.centerX)
            make.height.equalTo(50)
        }

        doingMissionButton.snp.makeConstraints { make in
            make.top.height.equalTo(myMissionButton)
            make.trailing.equalTo(profileStackView)
            make.leading.equalTo(view.snp.centerX)
        }

        inviteMissionButton.snp.makeConstraints { make in
            make.top.equalTo(doingMissionButton.snp.bottom).offset(20)
            make.leading.equalTo(myMissionButton.snp.leading)
            make.trailing.equalTo(doingMissionButton.snp.trailing)
        }
    }
}
// MARK: Previews
/*
 #if canImport(SwiftUI) && DEBUG
 import SwiftUI
 @available(iOS 13.0, *)
 struct SettingViewControllerRepresentable: UIViewControllerRepresentable {
 func makeUIViewController(context: Context) -> SettingViewController {
 SettingViewController(viewModel: SettingViewModel(
 coordinator: SettingCoordinator(
 navigationController: // UINavigationController())
 )
 )
 }
 func updateUIViewController(_ uiViewController: SettingViewController, context: Context) {

 }
 }

 @available(iOS 13.0, *)
 struct SettingViewControllerPreview: PreviewProvider {
 static var previews: some View {
 SettingViewControllerRepresentable()
 }
 }
 #endif
 */
