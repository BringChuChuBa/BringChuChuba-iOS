//
//  Network.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/13.
//

import Moya
import RxSwift
import Firebase

final class Network {
    // MARK: Properties
    static let shared = Network()
//    private let provider = MoyaProvider<Router>(plugins: [NetworkLoggerPlugin()]) // for logging
    private let provider = MoyaProvider<Router>()
    private let maximumRetry: Int = 50

    // MARK: Initializers
    private init() {}

    // MARK: API Calls
    func request<T>(with httpRequest: Router,
                    for returnType: T.Type)
    -> Single<T> where T: Decodable {
        return provider.rx.request(httpRequest)
//            .debug()
            .filterSuccessfulStatusCodes() // validate 200 ~ 299
            .map(T.self) // decode
            .catchError { [weak self] err in
                print(err.localizedDescription)

                self?.fetchToken { _ in }
                throw err
            }
            .retry(maximumRetry)
    }

    func requests<T>(with httpRequest: Router,
                     for returnType: T.Type)
    -> Single<[T]> where T: Decodable {
        return provider.rx.request(httpRequest)
            .filterSuccessfulStatusCodes()
            .map([T].self)
            .catchError { [weak self] err in
                print(err.localizedDescription)

                self?.fetchToken { _ in }
                throw err
            }
            .retry(maximumRetry)
    }
}

// MARK: Firebase
extension Network {
    typealias completionToken = (String) -> Void

    func fetchToken(completion: @escaping completionToken) {
        // signIn
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            // token
            guard let user = authResult?.user else { return }
            user.getIDTokenForcingRefresh(false) { token, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                if let token = token {
                    GlobalData.shared.userToken = token

                    completion(token)
                }
            }
        }
    }
}
