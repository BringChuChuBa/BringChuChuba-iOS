//
//  Router.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/01/13.
//

import Moya

var Provider: MoyaProvider<Router> = MoyaProvider<Router>()

enum Router {
    case getMember
    case changeNickName(nickname: String)
    case getFamily(familyUid: Int)
    case createFamily(familyName: String)
    case joinFamily(familyId: String)
    case getMissions(familyId: String)
    case createMission(missionDetails: MissionDetails)
    case contractMission(missionUid: Int)
    case completeMission(missionUid: Int)
    case deleteMission(missionUid: Int)
    case changeDeviceToken(deviceToken: String)
}

extension Router: TargetType {
    // MARK: URL
    var baseURL: URL {
        guard let baseURL = try? Server.baseURL.asURL() else { fatalError() }
        return baseURL
    }

    // MARK: Path
    var path: String {
        switch self {
        case .getMember:
            return "/member"
        case .getFamily, .createFamily, .joinFamily:
            return "/family"
        case .getMissions, .createMission:
            return "/mission"
        case .changeNickName:
            return "/member/nickname"
        case .changeDeviceToken:
            return "/member/device"
        case .contractMission(let missionUid):
            return "/mission/contractor/\(missionUid)"
        case .completeMission(let missionUid):
            return "/mission/client/\(missionUid)"
        case .deleteMission(let missionUid):
            return "/mission/\(missionUid)"
        }
    }

    // MARK: HTTPMethod
    var method: Method {
        switch self {
        case .getMember, .getFamily, .getMissions:
            return .get
        case .createFamily, .createMission, .changeNickName:
            return .post
        case .joinFamily:
            return .put
        case .contractMission, .completeMission, .changeDeviceToken:
            return .patch
        case .deleteMission:
            return .delete
        }
    }

    var sampleData: Data {
        switch self {
        case .getMember:
            return "\"familyId\": \"string\", \"id\": \"string\", \"nickname\": \"string\", \"point\": \"string\" }".utf8Encoded
        default:
            return Data()
        }
    }

    // MARK: Parameters
    // URLEncoding.queryString : query
    // JSONEncoding.default : body
    var task: Task {
        switch self {
        case .getMember, .contractMission, .completeMission, .deleteMission:
            return .requestPlain
        case .getFamily(let familyUid):
            return .requestParameters(parameters: ["family_uid": familyUid],
                                      encoding: URLEncoding.queryString)
        case .createFamily(let familyName):
            return .requestParameters(parameters: ["name": familyName],
                                      encoding: JSONEncoding.default)
        case .joinFamily(let familyId):
            return .requestParameters(parameters: ["familyId": familyId],
                                      encoding: JSONEncoding.default)
        case .getMissions(let familyId):
            return .requestParameters(parameters: ["familyId": familyId],
                                      encoding: URLEncoding.queryString)
        case .createMission(let missionDetails):
            return .requestParameters(parameters: ["description": missionDetails.description,
                                                   "expireAt": missionDetails.expireAt,
                                                   "familyId": missionDetails.familyId,
                                                   "reward": missionDetails.reward,
                                                   "title": missionDetails.title],
                                      encoding: JSONEncoding.default)
        case .changeNickName(let nickname):
            return .requestParameters(parameters: ["nickname": nickname],
                                      encoding: JSONEncoding.default)
        case .changeDeviceToken(let deviceToken):
            return .requestParameters(parameters: ["deviceToken": deviceToken],
                                      encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [
            HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue,
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
            HTTPHeaderField.authorization.rawValue: GlobalData.shared.userToken
        ]
    }
}

// MARK: Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
