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
    // indicator
    private lazy var activityIndicator = UIActivityIndicatorView().then {
        // color constants로 뺴기
        $0.color = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
    }

    // profiles
    private lazy var profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private lazy var nameStackView = UIStackView().then {
        $0.axis = .vertical
//        $0.spacing = 5
        $0.alignment = .firstBaseline
        $0.distribution = .fillEqually
    }

    private lazy var profileImage = UIImageView().then {
        // TODO: 서버에서 프로필 사진 받아와서 연결
        $0.image = UIImage(systemName: "person.fill")
    }

    private lazy var nicknameLabel = UILabel().then {
        $0.text = GlobalData.shared.nickname + GlobalData.shared.id
    }

    private lazy var idLabel = UILabel().then {
        $0.text = "가족방 ID: " + GlobalData.shared.familyId
        $0.textColor = .gray
    }

    // button stacks
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        //        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .fillEqually
//        $0.backgroundColor = .systemPink
    }

    private lazy var myMissionStackView = UIStackView().then {
        $0.axis = .vertical
        //        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .fillEqually
//        $0.backgroundColor = .purple
    }

    private lazy var doingMissionStackView = UIStackView().then {
        $0.axis = .vertical
        //        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .fillEqually
    }

    private lazy var inviteFamilyStackView = UIStackView().then {
        $0.axis = .vertical
        //        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .fillEqually
    }

    // buttons
    private lazy var myMissionButton = UIButton(type: .system).then {
        $0.setTitle("Setting.MyMissionButton.Title".localized, for: .normal)
        $0.setTitleColor(.black, for: .normal)

        //        $0.clipsToBounds = true
        //        $0.layer.cornerRadius = 10
        //        $0.layer.borderWidth = 1
        //        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    private lazy var doingMissionButton = UIButton(type: .system).then {
        $0.setTitle("Setting.DoingMissionButton.Title".localized, for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    private lazy var inviteFamilyButton = UIButton(type: .system).then {
        $0.setTitle("Setting.InviteFamilyButton.Title".localized, for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    // image stacks
    private lazy var myMissionImage = UIImageView().then {
        $0.image = UIImage(systemName: "book.closed")
        $0.contentMode = .scaleAspectFit
//        $0.backgroundColor = .brown
    }

    private lazy var doingMissionImage = UIImageView().then {
        $0.image = UIImage(systemName: "square.and.pencil")
        $0.contentMode = .scaleAspectFit
//        $0.backgroundColor = .yellow
    }

    private lazy var inviteFamilyImage = UIImageView().then {
        $0.image = UIImage(systemName: "link")
        $0.contentMode = .scaleAspectFit
//        $0.backgroundColor = .red
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

        let myMissionTrigger = Driver.merge(
            myMissionImage.rx.tap().asDriverOnErrorJustComplete(),
            myMissionButton.rx.tap.asDriver()
        )

        let doingMissionTrigger = Driver.merge(
            doingMissionImage.rx.tap().asDriverOnErrorJustComplete(),
            doingMissionButton.rx.tap.asDriver()
        )

        let inviteFamilyTrigger = Driver.merge(
            inviteFamilyImage.rx.tap().asDriverOnErrorJustComplete(),
            inviteFamilyButton.rx.tap.asDriver()
        )

        let input = SettingViewModel.Input(
            photoTrigger: profileImage.rx.tap().asDriverOnErrorJustComplete(),
            myMissionTrigger: myMissionTrigger,
            doingMissionTrigger: doingMissionTrigger,
            inviteFamilyTrigger: inviteFamilyTrigger
        )

        let output = viewModel.transform(input: input)
        
        [output.myMission
            .drive(),
         output.doingMission
            .drive(),
         output.profile
            .drive(),
         output.invite
            .drive(activityIndicator.rx.isAnimating),
         output.complete
            .drive(activityIndicator.rx.isAnimating)
        ].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        navigationItem.title = "Setting.Navigation.Title".localized
        navigationItem.largeTitleDisplayMode = .always

        // add subviews
        view.addSubview(profileStackView)
        view.addSubview(buttonStackView)
        view.addSubview(activityIndicator)

        profileStackView.addArrangedSubview(profileImage)
        profileStackView.addArrangedSubview(nameStackView)

        nameStackView.addArrangedSubview(nicknameLabel)
        nameStackView.addArrangedSubview(idLabel)

        buttonStackView.addArrangedSubview(myMissionStackView)
        buttonStackView.addArrangedSubview(doingMissionStackView)
        buttonStackView.addArrangedSubview(inviteFamilyStackView)

        myMissionStackView.addArrangedSubview(myMissionImage)
        myMissionStackView.addArrangedSubview(myMissionButton)

        doingMissionStackView.addArrangedSubview(doingMissionImage)
        doingMissionStackView.addArrangedSubview(doingMissionButton)

        inviteFamilyStackView.addArrangedSubview(inviteFamilyImage)
        inviteFamilyStackView.addArrangedSubview(inviteFamilyButton)

        // set constraints

        // indicator
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // profiles
        profileStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.height.equalTo(100)
        }

        profileImage.snp.makeConstraints { make in
            make.height.equalTo(profileImage.snp.width)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.width.equalTo(idLabel.snp.width)
        }

        myMissionImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        doingMissionImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        inviteFamilyImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom)
            make.leading.trailing.equalTo(profileStackView)
            make.height.equalTo(150)
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
