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
    var parameter: ParameterType? { get }
}

enum APIRouter: APICofiguration {
    case getMember
    case getFamily(familyId: Int)

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getMember, .getFamily:
            return .get
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .getMember:
            return "member"
        case .getFamily:
            return "family"
        }
    }

    // MARK: - Parameters
    var parameter: ParameterType? {
        switch self {
        case .getFamily(let familyId):
            return .query(["family_uid": String(familyId)])
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

        // Parameters
        switch parameter {
        case .body(let parameter):
            let bodyData = try? JSONSerialization.data(withJSONObject: parameter, options: [])
            if let data = bodyData {
                urlRequest.httpBody = data
            }
        case .query(let parameter):
            let queryParams = parameter.map { URLQueryItem(name: $0.key, value: $0.value) }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url

        default:
            break
        }

        return urlRequest
    }
}
