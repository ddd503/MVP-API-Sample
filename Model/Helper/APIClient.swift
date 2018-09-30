//
//  APIClient.swift
//  Model
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Alamofire

enum APIRequestResult {
    case success(Data)
    case failure(Error)
}

final class APIClient {
    static func request(option: RequestOption, completionHandler: @escaping (APIRequestResult) -> ()) {
        Alamofire.request(option).responseData { response in
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
