//
//  UsersViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SettingViewController: UIViewController {
    // MARK: - Properties
    var viewModel: SettingViewModel!
    private let disposeBag = DisposeBag()
    private let tapGesture = UITapGestureRecognizer()

    // navigation Items
    private lazy var titleLabel: UILabel = UILabel().then { label in
        let attributedString = NSAttributedString(string: NSLocalizedString("나의 쭈쭈바", comment: ""),
                                                  attributes: [
                                                    .font: UIFont.systemFont(ofSize: 16.0),
                                                    .foregroundColor: UIColor.black
                                                  ])
        label.attributedText = attributedString
    }

    private lazy var titleBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: titleLabel)

    // profiles
    private lazy var profileStackView: UIStackView = UIStackView().then { stack in
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
    }

    private lazy var nameStackView: UIStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .firstBaseline
        stack.distribution = .fillEqually
    }

    private lazy var photo: UIImageView = UIImageView().then { image in
        image.image = UIImage(named: "profile")
        image.addGestureRecognizer(tapGesture)
    }

    private lazy var nicknameLabel: UILabel = UILabel().then { label in
        label.text = GlobalData.shared.nickname
    }

    private lazy var idLabel: UILabel = UILabel().then { label in
        label.text = GlobalData.shared.id
    }

    // buttons
    private lazy var myMissionButton: UIButton = UIButton(type: .system).then { button in
        button.setTitle("myMission", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    private lazy var doingMissionButton: UIButton = UIButton(type: .system).then { button in
        button.setTitle("doingMission", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    // MARK: - Initializers
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
    }
}

// MARK: - Binds
extension SettingViewController {
    func bindViewModel() {
        assert(viewModel.isSome)
        
        let input = SettingViewModel.Input(photoTrigger: tapGesture.rx.event.asDriver(),
                                           myMissionTrigger: myMissionButton.rx.tap.asDriver(),
                                           doingMissionTrigger: doingMissionButton.rx.tap.asDriver())

        let output = viewModel.transform(input: input)

        [output.myMission
            .drive(),
         output.doingMission
            .drive(),
         output.profile
            .drive()
        ].forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - Set UIs
extension SettingViewController {
    func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)

        navigationItem.leftBarButtonItem = titleBarButtonItem

        // add subviews
        view.addSubview(profileStackView)

        profileStackView.addArrangedSubview(photo)
        profileStackView.addArrangedSubview(nameStackView)

        nameStackView.addArrangedSubview(nicknameLabel)
        nameStackView.addArrangedSubview(idLabel)

        view.addSubview(myMissionButton)
        view.addSubview(doingMissionButton)

        // set constraints

        // profiles
        profileStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.height.equalTo(100)
        }

        photo.snp.makeConstraints { make in
            make.height.equalTo(photo.snp.width)
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
    }
}

// MARK: - Previews

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct SettingViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SettingViewController {
        SettingViewController(viewModel: SettingViewModel(coordinator: SettingCoordinator(navigationController: UINavigationController())))
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
