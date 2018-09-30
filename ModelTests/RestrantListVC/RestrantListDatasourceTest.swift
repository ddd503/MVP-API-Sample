//
//  RestrantListDatasourceTest.swift
//  ModelTests
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import Model
import XCTest

final class RestrantListDatasourceTest: XCTestCase {
    
    func test_レストラン検索APIを叩いて店舗情報を取得するテスト() {
        let requestDatasourceExpectation = self.expectation(description: "requestDatasource")
        /// 東京都の「銀座・有楽町・築地」のレストランを検索する
        APIClient.request(option: .searchRestrantAPI(areaCode: "AREAL2101",
                                                     offsetPageCount: 1,
                                                     recordCount: 3)) {[weak self] result in
                                                        requestDatasourceExpectation.fulfill()
                                                        switch result {
                                                        case .success(let data):
                                                            XCTAssertNotNil(data)
                                                            self?.test_レストラン検索APIから指定した数の店舗情報を取得しマッピングするテスト(data: data)
                                                        default:
                                                            XCTFail()
                                                        }
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    // 上記のテストの続き
    func test_レストラン検索APIから指定した数の店舗情報を取得しマッピングするテスト(data: Data) {
        do {
            let decoder = JSONDecoder()
            let restrantData = try decoder.decode(ResrantData.self, from: data)
            XCTAssertTrue(restrantData.info.count == 3)
            XCTAssertNotNil(restrantData.totalHitCount)
            XCTAssertNotNil(restrantData.pageOffset)
            XCTAssertNotNil(restrantData.hitPage)
            XCTAssertNotNil(restrantData.info.first?.name)
            XCTAssertNotNil(restrantData.info.first?.address)
            XCTAssertNotNil(restrantData.info.first?.tel)
            XCTAssertNotNil(restrantData.info.first?.fee)
            XCTAssertNotNil(restrantData.info.first?.imageUrlString.shopUrlstring)
            XCTAssertNotNil(restrantData.info.first?.access.station)
            XCTAssertNotNil(restrantData.info.first?.access.walkTime)
        } catch {
            XCTFail()
        }
    }
    
}
