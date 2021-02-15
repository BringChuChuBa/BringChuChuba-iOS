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

    // MARK: Initializers
    private init() {}

    // MARK: API Calls
    /// API Calls
    /// - Parameters:
    ///   - httpRequest: Request Router Type (getMember, getMission...)
    ///   - returnType: Decode Type (Mission.self, Member.self ...)
    /// - Returns: Single Stream
    /// - Errors : 에러 발생 시 (토큰 만료 or 네트워크 오류) fetchToken 후 1초 후 재시도
    ///         4번 재시도 (첫 1회 시도 포함) 후 return
    func request<T>(with httpRequest: Router,
                    for returnType: T.Type)
    -> Single<T> where T: Decodable {
        return provider.rx.request(httpRequest)
//            .debug()
            .filterSuccessfulStatusCodes() // validate 200 ~ 299
            .map(T.self) // decode
            .catchError { [weak self] err in
                print(err.localizedDescription)

                self?.signInAnonymously { _ in }
                throw err
            }
            .retryWhen { error in
                error.enumerated().flatMap { tryCount, error -> Observable<Int> in
                    let maximumRetry: Int = 5
                    if tryCount > maximumRetry {
                        return Observable.error(error)
                    }
                    return Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
                    // .take(1)
                }
            }
    }

    func requests<T>(with httpRequest: Router,
                     for returnType: T.Type)
    -> Single<[T]> where T: Decodable {
        return provider.rx.request(httpRequest)
            .filterSuccessfulStatusCodes()
            .map([T].self)
            .catchError { [weak self] err in
                print(err.localizedDescription)

                self?.signInAnonymously { _ in }
                throw err
            }
            .retryWhen { error in
                error.enumerated().flatMap { tryCount, error -> Observable<Int> in
                    let maximumRetry: Int = 5
                    if tryCount > maximumRetry {
                        return Observable.error(error)
                    }
                    return Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
                    // .take(1)
                }
            }
    }
}

// MARK: Firebase
extension Network {
    typealias Completion = (String) -> Void

    func signInAnonymously(completion: @escaping Completion) {
        // signIn
        Auth.auth().signInAnonymously { [weak self] _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            self?.fetchToken { token in
                completion(token)
            }

//            // token
//            guard let user = authResult?.user else { return }
//            user.getIDTokenForcingRefresh(false) { token, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//
//                if let token = token {
//                    GlobalData.shared.userToken = token
//
//                    completion(token)
//                }
//            }
        }
    }

    private func fetchToken(completion: @escaping Completion) {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(false) { token, error in
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
