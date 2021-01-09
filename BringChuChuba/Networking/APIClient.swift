//
//  APIClient.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/06.
//

import Foundation
import Alamofire
import SwiftyJSON

final class APIClient {
    typealias CompletionHandler<T: Codable> = (Result<T, Error>) -> Void

    static func getMember(
        completion: @escaping CompletionHandler<Member>
    ) {
        AF.request(APIRouter.getMember)
//            .validate()
            .responseDecodable(of: Member.self) { (response) in
                switch response.result {
                case .success(let member):
                    completion(.success(member))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    static func getFamily(
        familyId: Int,
        completion: @escaping CompletionHandler<Family>
    ) {
        AF.request(APIRouter.getFamily(familyId: familyId))
            .validate()
            .responseDecodable(of: Family.self) { (response) in
                switch response.result {
                case .success(let family):
                    completion(.success(family))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    static func createFamily(
        familyName: String,
        completion: @escaping CompletionHandler<Family>
    ) {
        AF.request(APIRouter.createFamily(familyName: familyName))
            .validate()
            .responseDecodable(of: Family.self) { (response) in
                switch response.result {
                case .success(let family):
                    completion(.success(family))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    static func joinFamily(
        familyId: Int,
        completion: @escaping CompletionHandler<Family>
    ) {
        AF.request(APIRouter.joinFamily(familyId: familyId))
            .validate()
            .responseDecodable(of: Family.self) { (response) in
                switch response.result {
                case .success(let family):
                    completion(.success(family))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    static func getMissions(
        familyId: Int,
        completion: @escaping CompletionHandler<[Mission]>
    ) {
        AF.request(APIRouter.getMissions(familyId: familyId))
            .validate()
            .responseDecodable(of: [Mission].self) { (response) in
                switch response.result {
                case .success(let missions):
                    completion(.success(missions))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    static func createMission(
        missionDetails: NetworkConstatns.MissionDetails,
        completion: @escaping CompletionHandler<Mission>
    ) {
        AF.request(APIRouter.createMission(missionDetails: missionDetails))
            .validate()
            .responseDecodable(of: Mission.self) { (response) in
                switch response.result {
                case .success(let mission):
                    completion(.success(mission))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
