//
//  APIClient.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/06.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    static func getMember(completion:@escaping (Result<Member, AFError>) -> Void) {
        let decoder = JSONDecoder()
        AF.request(APIRouter.getMember)
            .responseDecodable(decoder: decoder) { (response) in
                completion(response.result)
            }
    }
}
