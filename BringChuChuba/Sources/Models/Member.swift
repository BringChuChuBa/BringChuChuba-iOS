//
//  Member.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import Foundation

struct Member: Decodable, Hashable {
    let id: String
    let familyId: String?
    let nickname: String?
    let point: String?
}
