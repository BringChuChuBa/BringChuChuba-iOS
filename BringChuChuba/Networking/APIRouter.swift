//
//  APIRouter.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/05.
//

import Alamofire
import Firebase

enum APIRouter: APICofiguration {

    case getMember

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getMember:
            return .get
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .getMember:
            return "member"
        }
    }

    // MARK: - Parameters
    var parameter: RequestParams? {
        switch self {
        default:
            return nil
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constatns.ProductionServer.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
            urlRequest.setValue(appDelegate.token, forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
}
