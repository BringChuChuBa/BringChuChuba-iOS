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
    case getFamily(familyId: String)
    case createFamily(familyName: String)
    case joinFamily(familyId: String)
    case getMissions(familyId: String)
    case createMission(missionDetails: NetworkConstants.MissionDetails)

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getMember, .getFamily, .getMissions:
            return .get
        case .createFamily, .createMission:
            return .post
        case .joinFamily:
            return .put
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .getMember:
            return "member"
        case .getFamily, .createFamily, .joinFamily:
            return "family"
        case .getMissions, .createMission:
            return "mission"
        }
    }

    // MARK: - Parameters
    var parameter: ParameterType? {
        switch self {
        case .getFamily(let familyId):
            return .query(["family_uid": familyId])
        case .createFamily(let familyName):
            return .body(["name": familyName])
        case .joinFamily(let familyId):
            return .body(["familyId": familyId])
        case .getMissions(let familyId):
            return .query(["familyId": familyId])
        case .createMission(let missionDetails):
            return .body(
                ["description": missionDetails.description,
                 "expireAt": missionDetails.expireAt,
                 "familyId": missionDetails.familyId,
                 "reward": missionDetails.reward,
                 "title": missionDetails.title]
            )
        default:
            return nil
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkConstants.ProductionServer.baseURL.asURL()

        // Path
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        // Custom Headers
        urlRequest.setValue(GlobalData.shared.userToken, forHTTPHeaderField: "Authorization")

        // Parameters
        switch parameter {
        case .body(let parameter):
            urlRequest = try JSONParameterEncoder().encode(parameter, into: urlRequest)
        case .query(let parameter):
            urlRequest = try URLEncodedFormParameterEncoder().encode(parameter, into: urlRequest)
        default:
            break
        }
        return urlRequest
    }
}
