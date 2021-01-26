//
//  Mission.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import Foundation

enum Status: String, Decodable {
    case todo
    case inProgress
    case complete
}

struct Mission: Decodable {
    let client: Member
    var contractor: Member?
    let createdAt: String
    var description: String?
    var expireAt: String
    let familyId: String
    let id: String
    var modifiedAt: String
    var reward: String
    var status: Status
    var title: String
}

struct MissionDetails {
    let description: String
    let expireAt: String
    let familyId: String
    let reward: String
    let title: String
}
