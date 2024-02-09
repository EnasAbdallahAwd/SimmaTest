//
//  APIRequestHandler.swift


import Foundation
import Alamofire

typealias CallResponses<T> = ((ServerResponse<T>) -> Void)?

protocol APIRequestHandler: HandleAlamoResponse { }

struct UploadData {
    var data: Data
    var fileName, mimeType, name: String
}

extension APIRequestHandler {

    private func uploadToServerWith<T: CodableInit>(_ decoder: T.Type, data: [UploadData], request: URLRequestConvertible, parameters: Parameters?, progress: ((Progress) -> Void)?, completion: CallResponses<T>) {

        AF.upload(multipartFormData: { mul in
            data.forEach({ mul.append($0.data, withName: $0.name, fileName: $0.fileName, mimeType: $0.mimeType) })
            guard let parameters = parameters else { return }
            for (key, value) in parameters {
                mul.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, with: request).responseData { results in
            self.handleResponse(results, completion: completion)
        }.responseString { string in
            debugPrint(string.value as Any)
        }
    }
}

extension APIRequestHandler where Self: URLRequestBuilder {
    func send<T: CodableInit>(_ decoder: T.Type, data: [UploadData]? = nil, progress: ((Progress) -> Void)? = nil, debug: ((AFDataResponse<Any>) -> Void)? = nil, completion: CallResponses<T>) {
        if let data = data {
            uploadToServerWith(decoder, data: data, request: self, parameters: self.parameters, progress: progress, completion: completion)
        } else {
            AF.request(self).validate().responseData {
                self.handleResponse($0, completion: completion)
                }.responseJSON { results in
                    print(results)
                    debug?(results)
                    let res = results.value as? [String: Any]
                    print(res?["status"] as Any)
            }
        }
    }
}
