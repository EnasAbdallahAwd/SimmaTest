//
//  URLRequestBuilder.swift


import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible, APIRequestHandler {
    
    var mainURL: URL { get }
    var requestURL: URL { get }
    // MARK: - Path
    var path: String { get }
    
    var headers: HTTPHeaders { get }
    // MARK: - Parameters
    var parameters: Parameters? { get }
    
    // MARK: - Methods
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
    
    //var fcmTokenDevice: String { get }
}

extension URLRequestBuilder {
    
    var mainURL: URL {

        return URL(string: "https://unofficial-shein.p.rapidapi.com")!
    }
    

    var requestURL: URL {
        print(mainURL.appendingPathComponent(path))
        return mainURL.appendingPathComponent(path)
    }
    
    
    var headers: HTTPHeaders {
        var header = HTTPHeaders()
        
            header["X-RapidAPI-Key"] = "790a0de650mshcbdae7065bc4132p13c99bjsne5fcd9f686f3"
            header["X-RapidAPI-Host"] = "unofficial-shein.p.rapidapi.com"
          
            print(header)
        return header
    }
    
    var userToken: String? {
        return ""
    }
    
    var defaultParams: Parameters {
        let param = Parameters()
        return param
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.name) })
      //  print(urlRequest)
        return request
    }
    
//    var fcmTokenDevice: String {
//        return Messaging.messaging().fcmToken ?? ""
//    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

