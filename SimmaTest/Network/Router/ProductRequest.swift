//
//  ProductRequest.swift
//  SimmaTest
//
//  Created by Enas Abdallah on 09/02/2024.
//

import Foundation
import Alamofire

enum ProductRequest: URLRequestBuilder {
    
    /// Cases
    case productDetails(goolsID:String)
    
    // MARK: - Paths
    internal var path: String {
        switch self {
        case .productDetails:
            return "/products/detail"
       
        }
    }
    
    
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = defaultParams
        switch self {
        case let .productDetails(goodsId) :
            params ["goods_id"]  =  goodsId

        }
        print(params)
        
        return params
    }
    
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        switch self {
        case .productDetails:
            return .get

        }
    }
    
    
    // MARK: - Encoding
    internal var encoding: ParameterEncoding {
        switch method {
        case .post:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    
}


