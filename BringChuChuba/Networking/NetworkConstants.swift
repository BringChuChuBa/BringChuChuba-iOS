//
//  Constants.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/05.
//

import Foundation

struct Server {
    static let baseURL = "http://ec2-13-209-157-42.ap-northeast-2.compute.amazonaws.com:8080"
}

struct MissionDetails {
    let description: String
    let expireAt: String
    let familyId: String
    let reward: String
    let title: String
}

enum HTTPHeaderField: String {
    case authorization = "Authorization"
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
