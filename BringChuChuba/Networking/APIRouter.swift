//
//  APIRouter.swift
//  BringChuChuba
//
//  Created by 홍다희 on 2021/01/05.
//

import Alamofire
import Firebase

protocol APICofiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: RequestParams? { get }
}

enum APIRouter: APICofiguration {
    case getMember
    case createFamily(name: String)

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getMember:
            return .get
        case .createFamily:
            return .post
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .getMember:
            return "member"
        case .createFamily:
            return "family"
        }
    }

    // MARK: - Parameters
    var parameter: RequestParams? {
        switch self {
        default:
            return nil
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constatns.ProductionServer.baseURL.asURL()

        // Path
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        // Custom Headers
        let testToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImUwOGI0NzM0YjYxNmE0MWFhZmE5MmNlZTVjYzg3Yjc2MmRmNjRmYTIiLCJ0eXAiOiJKV1QifQ.eyJwcm92aWRlcl9pZCI6ImFub255bW91cyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9maXItc3ByaW5nYm9vdC00MjI1ZCIsImF1ZCI6ImZpci1zcHJpbmdib290LTQyMjVkIiwiYXV0aF90aW1lIjoxNjA5NzYxNjQ1LCJ1c2VyX2lkIjoiZlRvQXN4d1F3UmJWSmZBUTNDdUY4bHpaQzVUMiIsInN1YiI6ImZUb0FzeHdRd1JiVkpmQVEzQ3VGOGx6WkM1VDIiLCJpYXQiOjE2MDk5MDE1NzIsImV4cCI6MTYwOTkwNTE3MiwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6e30sInNpZ25faW5fcHJvdmlkZXIiOiJhbm9ueW1vdXMifX0.G5qT3fmP7mIfz_3dZ0x5n-PFE2wcK3r-r96Jh8zQHla8f3u-Iqm_b8nQ7bL5tHNc2wZg-RocTCtCO-xy1dJ7gUhGR8zYOcvhIIE8Vkl4uthvBMXR4gZwYiJBQzSSZuKLHE9bfLSZ2x56joc-viufyYGV6ae6pm8MV4rLOUiW9LkureiRvR9iUxiN-8s_s9tffq6Nx5w1mUnzYoeH4WU7F5FcSYm--Bnl2XVMqz_0rtjFHjpY3QwJopCptKjlWQp5E9_JuuCN4qmm00VKqE-iqfkVE3GAIWfb5M2riVWOLvZ7VY9prKqQDvzLP1Pdq5Q3YVqMmWJ9vCotWXViXGmP4w"
        urlRequest.setValue(testToken, forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}
