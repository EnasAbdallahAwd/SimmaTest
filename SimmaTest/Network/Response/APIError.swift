//
//  APIError.swift


import Foundation

enum APIErrors: LocalizedError {

    case errorMessage(message: String)

    var localizedDescription: String {
        switch self {

        case let .errorMessage(message):
            return message
        }
    }
}


