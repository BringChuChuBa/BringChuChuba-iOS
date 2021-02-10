//
//  ErrorUtil.swift
//  BringChuChuba
//
//  Created by 한상진 on 2021/02/09.
//

import Foundation
import Alamofire

final class ErrorUtil {
    // MARK: Initializers
    static let shared = ErrorUtil()
    private init() {}

    // MARK: Enums
    enum ErrorType: Error {
        case noToken
        case noInternet
        case unknown
    }

    // MARK: Internal Methods
    func handleError(_ error: Error) {
        switch error {
        case let afError as AFError:
            handleNetworkError(afError)
        default:
            break
        }
    }

    // MARK: HandleError
    private func handleNetworkError(_ networkError: AFError) {
        switch networkError {
        case .createUploadableFailed(error: let error):
            print("[AFError]: createUploadableFailed \(error.localizedDescription)")
        case .createURLRequestFailed(error: let error):
            print("[AFError]: createURLRequestFailed \(error.localizedDescription)")
        case .downloadedFileMoveFailed(error: let error, source: _, destination: _):
            print("[AFError]: downloadedFileMoveFailed \(error.localizedDescription)")
        case .explicitlyCancelled:
            print("[AFError]: explicitlyCancelled ")
        case .invalidURL(url: let url):
            print("[AFError]: invalidURL \(url)")
        case .multipartEncodingFailed(reason: let reason):
            print("[AFError]: multipartEncodingFailed \(reason)")
        case .parameterEncodingFailed(reason: let reason):
            print("[AFError]: parameterEncodingFailed \(reason)")
        case .parameterEncoderFailed(reason: let reason):
            print("[AFError]: parameterEncoderFailed \(reason)")
        case .requestAdaptationFailed(error: let error):
            print("[AFError]: requestAdaptationFailed \(error)")
        case .requestRetryFailed(retryError: let retryError, originalError: _):
            print("[AFError]: requestRetryFailed \(retryError)")
        case .responseValidationFailed(reason: let reason):
            print("[AFError]: responseValidationFailed \(reason)")
        case .responseSerializationFailed(reason: let reason):
            print("[AFError]: responseSerializationFailed \(reason)")
        case .serverTrustEvaluationFailed(reason: let reason):
            print("[AFError]: serverTrustEvaluationFailed \(reason)")
        case .sessionDeinitialized:
            print("[AFError]: sessionDeinitialized ")
        case .sessionInvalidated(error: let error):
            print("[AFError]: sessionInvalidated \(String(describing: error?.localizedDescription))")
        case .sessionTaskFailed(error: let error):
            print("[AFError]: sessionTaskFailed \(error.localizedDescription)")
        case .urlRequestValidationFailed(reason: let reason):
            print("[AFError]: urlRequestValidationFailed \(reason)")
        }
    }
}
