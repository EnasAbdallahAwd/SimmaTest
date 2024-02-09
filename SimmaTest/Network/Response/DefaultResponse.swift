//
//  DefaultResponse.swift


import Foundation

struct DefaultResponse: Codable, CodableInit {
    var status: Int?
    var success: Bool?
    var message: String?
}


struct APIErrorResponse: CodableInit, Codable, LocalizedError {
    var message: String?
    var status: Int?

    var localizedDescription: String {
        switch status {
        case 400:
            return message ?? "invalid_token".localized
        case 401, 403:
//            return "invalid_token".localized
            return message  ?? "invalid_token".localized
        case 404:
            //return "notfound_error".localized
            return message ?? "notfound_error".localized
        case 500:
           // return "unknown_error".localized
            return message  ?? "unknown_error".localized
        case 200:
           // return "unknown_error".localized
            return message ?? "unknown_error".localized
        case 422:
           // return "unknown_error".localized
            return  message  ?? "unknown_error".localized
        default:
            return "bad_connection".localized
        }

    }
}
