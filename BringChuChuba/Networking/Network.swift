//
//  Network.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/13.
//

import Moya
import RxSwift

final class Network {
    // MARK: - Errors
    private enum RequestError: Error {
        case FamilyExist
        case Unknown
    }

    // MARK: - Initializers
    static let shared = Network()
    private init() {}

    // MARK: - Properties
//    private let provider = MoyaProvider<Router>(plugins: [NetworkLoggerPlugin()]) // for logging
    private let provider = MoyaProvider<Router>()

    // MARK: - API Calls
    func request<T>(with httpRequest: Router, for returnType: T.Type) -> Single<T> where T: Decodable {
        return provider.rx.request(httpRequest)
            .debug()
            .filterSuccessfulStatusCodes()
            .map(T.self)
            .catchError { err in
                throw err
            }
    }

    func requests<T>(with httpRequest: Router, for returnType: T.Type) -> Single<[T]> where T: Decodable {
        return provider.rx.request(httpRequest)
            .debug()
            .filterSuccessfulStatusCodes()
            .map([T].self)
            .catchError { err in
                throw err
            }
    }
}
