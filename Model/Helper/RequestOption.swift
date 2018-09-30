//
//  RequestOption.swift
//  Model
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Alamofire
import Keys

private let apiAccessKey = MVPAPISampleXcodeprojKeys().gurunaviApiKey
private let baseURL = "https://api.gnavi.co.jp/"
// 一度に取得するレコード数
private let getRecordCount = 50

enum RequestOption: URLRequestConvertible {
    case searchRestrantAPI(areaCode: String, offsetPageCount: Int)
    
    func asURLRequest() throws -> URLRequest {
        
        let (path, method, parameters): (String, HTTPMethod, [String: Any]) = {
            switch self {
            case .searchRestrantAPI(let areaCode, let offsetPageCount):
                return ("RestSearchAPI/v3/", .get, searchParameters(areaCode: areaCode, offsetPageCount: offsetPageCount))
            }
        }()
        
        if let url = URL(string: baseURL) {
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        } else {
            fatalError("url is nil")
        }
        
    }
    
    private func searchParameters(areaCode: String, offsetPageCount: Int) -> [String: Any] {
        return [
            "keyid": apiAccessKey,
            "areacode_l": areaCode,
            "hit_per_page": getRecordCount,
            "offset_page": offsetPageCount
        ]
    }
    
}
