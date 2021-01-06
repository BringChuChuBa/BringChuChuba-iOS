//
//  Mission.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import Foundation

struct Mission: Codable {
    let client: [Member]
    var contractor: [Member]
    var description: String
    let familyId: Int
    let id: Int
    var reward: String
    var status: String
    var title: String
}
