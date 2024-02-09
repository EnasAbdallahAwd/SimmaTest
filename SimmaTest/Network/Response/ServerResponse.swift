//
//  ServerResponse.swift



import Foundation

enum ServerResponse<T> {
    case success(T), failure(LocalizedError?)
}
