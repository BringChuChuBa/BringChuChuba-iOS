//  DoingMissionViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/19.
//

import Photos
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class ProfileViewController: UIViewController {
    // MARK: Properties
    private let viewModel: ProfileViewModel!
    private let disposeBag = DisposeBag()

    // MARK: UI Components
    private lazy var saveBarButtonItem = UIBarButtonItem().then {
        $0.title = "Common.Done".localized
        $0.style = .done
    }

    private lazy var profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200)).then {
        $0.image = UIImage(systemName: "person.fill")
        $0.roundShadowView()
    }

    private lazy var nickNameTextField = UITextField().then {
        // custom
        // TODO: 수정!
        $0.text = GlobalData.shared.nickname
        $0.placeholder = "Profile.NickNameTextField.Placeholder".localized
        $0.font = .systemFont(ofSize: 13)

        // default
        $0.textAlignment = .center
        $0.keyboardType = .default
        $0.returnKeyType = .done
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.clearButtonMode = .whileEditing
        $0.contentVerticalAlignment = .center
        $0.keyboardAppearance = .default
        $0.autocapitalizationType = .none
    }

    private lazy var warningLabel = UILabel().then {
        $0.text = "Profile.WarningLabel.Text".localized
        $0.font = $0.font.withSize(10)
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }

    //    private var profileBinding: Binder<Void> {
    //        return Binder(self, binding: { vc, _ in
    //            let alert =  UIAlertController(title: "Pick Profile Image",
    //                                           message: "choose photo",
    //                                           preferredStyle: .actionSheet)
    //            let library =  UIAlertAction(title: "사진앨범",
    //                                         style: .default) { _ in
    //                self.openLibrary()
    //            }
    //            let camera =  UIAlertAction(title: "카메라",
    //                                        style: .default) { _ in
    //                self.openCamera()
    //            }
    //            let cancel = UIAlertAction(title: "취소",
    //                                       style: .cancel)
    //
    //            alert.addAction(library)
    //            alert.addAction(camera)
    //            alert.addAction(cancel)
    //            vc.present(alert, animated: true, completion: nil)
    //        })
    //    }

    private var errorBinding: Binder<Error> {
        return Binder(self) { _, error in
            print(error.localizedDescription)
        }
    }

    // MARK: Initializers
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
    }

    // MARK: Binds
    private func bindViewModel() {
        assert(viewModel.isSome)

//        let profileDidSelected = profileImageView.rx
//            .tapGesture()
//            .when(.recognized)
            //            .flatMapLatest { return Observable<Void>.create { observer in
            //                    let alert =  UIAlertController(
            //                        title: AlertTiTle.title.rawValue,
            //                        message: AlertTiTle.message.rawValue,
            //                        preferredStyle: .actionSheet
            //                    )
            //                    let crop =  UIAlertAction(
            //                        title: AlertTiTle.crop.rawValue,
            //                        style: .default,
            //                        handler: { _ in
            //                            switch PHPhotoLibrary.authorizationStatus() {
            //                            case .denied:
            //                                //  self.settingAlert()
            //                                //  observer.onNext(())
            //                                break
            //                            case .notDetermined:
            //                                PHPhotoLibrary.requestAuthorization { state in
            //                                    if state == .authorized {
            //                                        DispatchQueue.main.async {
            //                                            observer.onNext(())
            //                                        }
            //                                    }
            //                                }
            //                            case .restricted:
            //                                break
            //                            case .authorized:
            //                                DispatchQueue.main.async {
            //                                    observer.onNext(())
            //                                }
            //                            case .limited:
            //                                break
            //                            @unknown default:
            //                                break
            //                            }
            //                }
            //                    )
            //                    let cancel = UIAlertAction(
            //                        title: AlertTiTle.cancle.rawValue,
            //                        style: .cancel
            //                    )
            //                    alert.addAction(crop)
            //                    alert.addAction(cancel)
            //
            //                    self.present(alert, animated: true, completion: nil)
            //
            //                    return Disposables.create()
            //                }
            //
            //            }
//            .flatMapLatest { [weak self] _ in
//                return UIImagePickerController.rx.createWithParent(self) { picker in
//                    picker.sourceType = .photoLibrary
//                    picker.allowsEditing = true
//                }
//                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
//                .take(1)
//            }
//            .map { $0[.originalImage] as? UIImage }

        let profileDidSelected = profileImageView.rx
            .tapGesture()
            .when(.recognized)

        _ = nickNameTextField.rx.text.orEmpty.asDriver()

        let input = ProfileViewModel.Input(
            profileTrigger: profileDidSelected,
            nickName: nickNameTextField.rx.text.orEmpty.asDriver(),
            saveTrigger: saveBarButtonItem.rx.tap.asDriver(),
            profileVC: self
        )

        let output = viewModel.transform(input: input)
        [output.error
            .drive(errorBinding),
         output.saveEnabled
            .drive(saveBarButtonItem.rx.isEnabled),
         output.profile
            .drive(profileImageView.rx.image)
        ].forEach { $0.disposed(by: disposeBag) }
    }

    // MARK: Set UIs
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Profile.Navigation.Title".localized
        navigationItem.rightBarButtonItem = saveBarButtonItem

        view.addSubview(profileImageView)
        view.addSubview(nickNameTextField)
        view.addSubview(warningLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
        }

        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    // TODO: ErrorUtil로 빼기, String 처리
//    private func settingAlert() {
//        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
//            let alert = UIAlertController(
//                title: "설정",
//                message: "\(appName)이 카메라 접근 x -> 설정화면",
//                preferredStyle: .alert
//            )
//
//            let cancel = UIAlertAction(title: "Common.Cancle".localized, style: .cancel)
//            let confirm = UIAlertAction(title: "Common.Default".localized, style: .default)
//
//            alert.addAction(cancel)
//            alert.addAction(confirm)
//
//            self.present(alert, animated: true)
//        }
//    }
}
