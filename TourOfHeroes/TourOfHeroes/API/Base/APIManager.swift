//
//  APIManager.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

public protocol APIManager {
    func request<ResultType: Codable>(_ request: APIRequest) -> APIPromise<ResultType>
}

public extension APIManager {
    
    func request<ResultType: Codable>(_ request: APIRequest) -> APIPromise<ResultType> {
        let dataRequest = AF.request(
            request.urlWithParam,
            method: request.method,
            parameters: request.params,
            encoding: request.encoding,
            headers: request.headers
        )
        return APIPromise(request: dataRequest)
    }
}
