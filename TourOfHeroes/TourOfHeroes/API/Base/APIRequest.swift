//
//  APIRequest.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

public class APIRequest: Initializable {
    public var url: String = ""
    public var urlWithParam: String {
        guard urlParams.count > 0 else { return url }
        var url = "\(self.url)?"
        for (key, value) in urlParams {
            url = "\(url)\(key)=\(value)&"
        }
        let _ = url.popLast()
        return url
    }
    public var method: Alamofire.HTTPMethod = .get
    public var urlParams: [String: String] = [:]
    public var params: Parameters?
    public var encoding: ParameterEncoding = JSONEncoding.default
    public var headers: HTTPHeaders = [:]
    
    public required init() {}
}
