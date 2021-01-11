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
    static let shared = APIClient()
    private init() {}

    typealias CompletionHandler<T: Codable> = (T?, Error?) -> Void

    func getMember(
        completion: @escaping CompletionHandler<Member>
    ) {
        AF.request(APIRouter.getMember)
            .validate()
            .validate(contentType: [ContentType.json.rawValue])
            .responseDecodable(of: Member.self) { response in
                switch response.result {
                case .success(let member):
                    completion(member, nil)
                case .failure(let error):
                    // 에러코드에 대한 특별한 처리가 필요하면 failure 블록 안에서 처리
                    completion(nil, error)
                }
            }
    }

    func getFamily(
        familyId: String,
        completion: @escaping CompletionHandler<Family>
    ) {
        AF.request(APIRouter.getFamily(familyId: familyId))
            .validate()
            .validate(contentType: [ContentType.json.rawValue])
            .responseDecodable(of: Family.self) { (response) in
                switch response.result {
                case .success(let family):
                    completion(family, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    func createFamily(
        familyName: String,
        completion: @escaping CompletionHandler<Family>
    ) {
        AF.request(APIRouter.createFamily(familyName: familyName))
            .validate()
            .validate(contentType: [ContentType.json.rawValue])
            .responseDecodable(of: Family.self) { (response) in
                switch response.result {
                case .success(let family):
                    completion(family, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    func joinFamily(
        familyId: String,
        completion: @escaping CompletionHandler<Family>
    ) {
        AF.request(APIRouter.joinFamily(familyId: familyId))
            .validate()
            .validate(contentType: [ContentType.json.rawValue])
            .responseDecodable(of: Family.self) { (response) in
                switch response.result {
                case .success(let family):
                    completion(family, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    func getMissions(
        familyId: String,
        completion: @escaping CompletionHandler<[Mission]>
    ) {
        AF.request(APIRouter.getMissions(familyId: familyId))
            .validate()
            .validate(contentType: [ContentType.json.rawValue])
            .responseDecodable(of: [Mission].self) { (response) in
                switch response.result {
                case .success(let missions):
                    completion(missions, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    func createMission(
        missionDetails: NetworkConstants.MissionDetails,
        completion: @escaping CompletionHandler<Mission>
    ) {
        AF.request(APIRouter.createMission(missionDetails: missionDetails))
            .validate()
            .validate(contentType: [ContentType.json.rawValue])
            .responseDecodable(of: Mission.self) { (response) in
                switch response.result {
                case .success(let missionDetails):
                    completion(missionDetails, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
