//
//  BaseViewController.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/02/13.
//

import UIKit

import RxSwift

final class MainViewController: UIViewController {
    // MARK: Properties
    private let coordinator: MainCoordinator
    var disposeBag: DisposeBag = DisposeBag()

    // MARK: Initializers
    init(with coordinator: MainCoordinator) {
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loginAndFetchToken()
    }

    // MARK: UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    // MARK: login
    private func loginAndFetchToken() {
        Network.shared.signInAnonymously { [weak self] token in
            guard let self = self else { return }
            self.fetchCurrentMember(with: token)
        }
    }
}

// MARK: FirebaseAuth
// AuthManager
extension MainViewController {
    private func fetchCurrentMember(with token: String) {
        // member
        Network.shared.request(with: .getMember,
                               for: Member.self)
            .subscribe(onSuccess: { [weak self] member in
                guard let self = self else { return }

                GlobalData.shared.do {
                    $0.id = member.id
                    if let point = member.point { $0.point = point }
                    if let familyId = member.familyId { $0.familyId = familyId }
                    if let nickname = member.nickname { $0.nickname = nickname }
                }
                
                self.coordinator.do {
                    GlobalData.shared.familyId.isEmpty ? $0.showLogin() : $0.showMainTab()
                }
            }, onError: { error in
                print(error.localizedDescription)
                return
            })
            .disposed(by: disposeBag)
    }
}
