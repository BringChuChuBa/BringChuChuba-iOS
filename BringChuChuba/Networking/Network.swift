//
//  Network.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/13.
//

import Moya
import RxSwift

final class Network {
    static let shared = Network()
    private init() {}

    private let provider = MoyaProvider<Router>(plugins: [NetworkLoggerPlugin()])
    private let disposeBag = DisposeBag()

    func getMember() -> Single<Member> {
        return provider.rx.request(.getMember)
            .debug()
            .filterSuccessfulStatusAndRedirectCodes()
            .map(Member.self)
    }
}
