//
//  APICofiguration.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/05.
//

import Foundation
import Alamofire

protocol APICofiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: RequestParams? { get }
}
