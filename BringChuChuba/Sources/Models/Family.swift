//
//  Family.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/04.
//

import Foundation

struct Family: Decodable {
    let id: String
    let members: [Member]
    let missions: [Mission]
    let name: String
}
