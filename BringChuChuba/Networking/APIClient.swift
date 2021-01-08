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
    // TODO: Generic 적용
    static func getMember(
        completion: @escaping (Result<Member, Error>) -> Void) {
        AF.request(APIRouter.getMember)
            .validate()
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
        completion: @escaping (Result<Family, Error>) -> Void) {
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
        completion: @escaping (Result<Family, Error>) -> Void) {
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
        completion: @escaping (Result<Family, Error>) -> Void) {
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
        completion: @escaping (Result<[Mission], Error>) -> Void) {
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
    // TODO: paramter type 별도로 만들어서 넘주는게 나은가?
    static func createMission(
        description: String,expireAt: String,
        familyId: Int,
        reward: String,
        title: String,
        completion: @escaping (Result<Mission, Error>) -> Void) {
        AF.request(APIRouter.createMission(description: description, expireAt: expireAt, familyId: familyId, reward: reward, title: title))
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
