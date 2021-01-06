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
//    @discardableResult
//    private static func performRequest<T: Decodable>(route: APIRouter, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, AFError>) -> Void) -> DataRequest{
//        return AF.request(route)
//            .responseDecodable(decoder: decoder){ (response: DataResponse<T, AFError>) in
//                completion(response.result)
//            }
//    }
    static func getMember(completion:@escaping (Result<Any, AFError>) -> Void) {
        AF.request(APIRouter.getMember)
            .responseJSON { (response) in
                completion(response.result)
            }
    }
//    static func createFamily(name: String, completion:@escaping (Result<Any, AFError>) -> Void) {
//        AF.request(APIRouter.createFamily(name: name))
//            .responseJSON { (response) in
//                completion(response.result)
//            }
//    }
}
