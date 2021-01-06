//
//  APIRouter.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/05.
//

import Alamofire
import Firebase

protocol APICofiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: RequestParams? { get }
}

enum APIRouter: APICofiguration {
    case getMember
    case createFamily(name: String)

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getMember:
            return .get
        case .createFamily:
            return .post
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .getMember:
            return "member"
        case .createFamily:
            return "family"
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

        // Path
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        // Custom Headers
        urlRequest.setValue(GlobalData.sharedInstance().userToken, forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}
