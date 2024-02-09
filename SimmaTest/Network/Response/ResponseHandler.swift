//
//  ResponseHandler.swift



import Foundation
import Alamofire

protocol HandleAlamoResponse {
    func handleResponse<T: CodableInit>(_ response: AFDataResponse<Data>, completion: CallResponses<T>)
}

extension HandleAlamoResponse {
    
    func handleResponse<T: CodableInit>(_ response: AFDataResponse<Data>, completion: CallResponses<T>) {
        print(response.result)
        switch response.result {
        
        case .failure(let error):
            guard let statusCode = response.response?.statusCode else {
                completion?(ServerResponse<T>.failure(error))
                return
            }
            do {
                let dresponse = try APIErrorResponse(data: response.data!)
                completion?(ServerResponse<T>.failure(APIErrorResponse(message: dresponse.message , status: statusCode)))
            } catch {
                completion?(ServerResponse<T>.failure(error as? LocalizedError))
            }
            
        case .success(let value):
            
            do {
                let dresponse = try DefaultResponse(data: value)
                let errorResponse = try APIErrorResponse(data: value)

                if (dresponse.status != 0) {
                    let modules = try T(data: value)
                    completion?(ServerResponse<T>.success(modules))
                } else {
                    completion?(ServerResponse<T>.failure(APIErrors.errorMessage(message: errorResponse.message  ?? "")))
                }
            } catch {
                print(ServerResponse<T>.failure(error as? LocalizedError))
                completion?(ServerResponse<T>.failure(error as? LocalizedError))
            }
        }
    }
}

