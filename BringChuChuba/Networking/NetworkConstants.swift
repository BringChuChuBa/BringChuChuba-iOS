//
//  Constants.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/05.
//

import Foundation
import Alamofire

struct NetworkConstants {
    struct ProductionServer {
        static let baseURL = "http://ec2-13-209-157-42.ap-northeast-2.compute.amazonaws.com:8080"
    }

    struct MissionDetails {
        let description: String
        let expireAt: String
        let familyId: String
        let reward: String
        let title: String
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case string = "String"
}

enum ContentType: String {
    case json = "application/json"
}

enum ParameterType {
    case query([String: String])
    case body([String: String])
}

// enum NetworkError: Error {
//     case Unauthorized // 401
//     case Forbidden // 403
//     case NotFound // 404
//     case Connection // TODO: 인터넷 연결이 안됐을 경우 404가 뜨는지? Reachability Check를 해야할지?
//     case Unknown
// }
