//
//  APIClientTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/09/24.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import Model
import XCTest

final class APIClientTest: XCTestCase {
    
    var apiClientExpectation: XCTestExpectation?
    
    func test_API通信を行いレスポンス結果を受けるテスト() {
        let requestApiExpectation = self.expectation(description: "request_API")
        APIClient.request(option: RequestOption.searchRestrantAPI(areaCode: "AREAL2101",
                                                                  offsetPageCount: 1,
                                                                  recordCount: 1)) { result in
            requestApiExpectation.fulfill()
            XCTAssertNotNil(result)
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
}
