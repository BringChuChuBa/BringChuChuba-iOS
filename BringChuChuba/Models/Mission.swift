//
//  Mission.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import Foundation

struct Mission: Codable {
    let client: Member
    var contractor: Member?
    let createdAt: String
    var description: String?
    var expireAt: String
    let familyId: String?
    let id: String?
    var modifiedAt: String
    var reward: String?
    var status: String
    var title: String
}
