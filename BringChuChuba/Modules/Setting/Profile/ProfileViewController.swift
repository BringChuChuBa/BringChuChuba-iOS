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
    var viewModel: ProfileViewModel!
    private let disposeBag = DisposeBag()
    //    private let tapGesture = UITapGestureRecognizer()
    private let picker = UIImagePickerController()

    // MARK: UI Components
    private lazy var saveBarButtonItem: UIBarButtonItem = UIBarButtonItem().then { button in
        button.title = "Common.Done".localized
        button.style = .done
    }

    private lazy var profileImageView: UIImageView = UIImageView().then { image in
        image.image = UIImage(named: "profile")
        //        image.addGestureRecognizer(tapGesture)
    }

    private lazy var nickNameTextField: UITextField = UITextField().then { field in
        // custom
        // TODO: 수정!
        field.text = GlobalData.shared.nickname
        field.placeholder = "Profile.NickNameTextField.Placeholder".localized
        field.font = .systemFont(ofSize: 13)

        // default
        field.textAlignment = .center
        field.keyboardType = .default
        field.returnKeyType = .done
        field.autocorrectionType = .no
        field.borderStyle = .roundedRect
        field.clearButtonMode = .whileEditing
        field.contentVerticalAlignment = .center
        field.keyboardAppearance = .default
        field.autocapitalizationType = .none
    }

    private lazy var warningLabel: UILabel = UILabel().then { label in
        label.text = "Profile.WarningLabel.Text".localized
        label.font = label.font.withSize(10)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
        return Binder(self, binding: { _, error in
            print(error.localizedDescription)
        })
    }

    // MARK: Initializers
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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

    // MARK: Methods
    // TODO: ErrorUtil로 빼기, String 처리
    private func settingAlert() {
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            let alert = UIAlertController(title: "설정",
                                          message: "\(appName)이 카메라 접근 x -> 설정화면",
                                          preferredStyle: .alert)

            let cancel = UIAlertAction(title: "Common.Cancle".localized,
                                       style: .cancel)

            let confirm = UIAlertAction(title: "Common.Default".localized,
                                        style: .default)

            alert.addAction(cancel)
            alert.addAction(confirm)

            self.present(alert,
                         animated: true)
        }
    }
}

// MARK: Binds
extension ProfileViewController {
    func bindViewModel() {
        assert(viewModel.isSome)

        let profileDidSelected = profileImageView.rx.tap()
            .flatMapLatest {
                return Observable<Void>.create { observer in
                    let alert =  UIAlertController(title: AlertTiTle.title.rawValue,
                                                   message: AlertTiTle.message.rawValue,
                                                   preferredStyle: .actionSheet)
                    let crop =  UIAlertAction(title: AlertTiTle.crop.rawValue,
                                              style: .default,
                                              handler: { _ -> Void in
                                                switch PHPhotoLibrary.authorizationStatus() {
                                                case .denied:
                                                    //                                                    self.settingAlert()
                                                    //                                                    observer.onNext(())
                                                    break
                                                case .notDetermined:
                                                    PHPhotoLibrary.requestAuthorization { state in
                                                        if state == .authorized {
                                                            DispatchQueue.main.async {
                                                                observer.onNext(())
                                                            }
                                                        }
                                                    }
                                                case .restricted:
                                                    break
                                                case .authorized:
                                                    DispatchQueue.main.async {
                                                        observer.onNext(())
                                                    }
                                                case .limited:
                                                    break
                                                @unknown default:
                                                    break
                                                }
                                              })
                    let cancel = UIAlertAction(title: AlertTiTle.cancle.rawValue,
                                               style: .cancel)
                    alert.addAction(crop)
                    alert.addAction(cancel)

                    self.present(alert, animated: true, completion: nil)

                    return Disposables.create()
                }
            }
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                }
            }
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            //            .take(1)
            .map { info in
                return info[.editedImage] as? UIImage
            }

        let input = ProfileViewModel.Input( // profileTrigger: profileObservable.asDriverOnErrorJustComplete(),
            nickName: nickNameTextField.rx.text.orEmpty.asDriver(),
            saveTrigger: saveBarButtonItem.rx.tap.asDriver())

        let output = viewModel.transform(input: input)

        [output.error
            .drive(errorBinding),
         //         output.profile
         //            .drive(profileImage.rx.image),
         output.saveEnabled
            .drive(saveBarButtonItem.rx.isEnabled),
         profileDidSelected
            .bind(to: profileImageView.rx.image)
        ].forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: Set UIs
extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = saveBarButtonItem

        view.addSubview(profileImageView)
        view.addSubview(nickNameTextField)
        view.addSubview(warningLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.width.height.equalTo(150)
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
}

extension ProfileViewController {
    func openLibrary() {
        picker.sourceType = .photoLibrary

        present(picker, animated: false, completion: nil)

    }

    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera

            present(picker, animated: false, completion: nil)
        } else {
            print("Camera not available")
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            profileImageView.image = image

            print(info)
        }

        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController {
    enum AlertTiTle: String {
        case title = "Pick Profile Image"
        case message = "choose photo"
        case crop
        case cancle
    }
}
