//
//  RestrantListDatasourceTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/09/24.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import MVP_API_Sample
import XCTest

final class RestrantListDatasourceTest: XCTestCase {
    
    private let datasource = RestrantListDatasource()
    private var requestDatasourceExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        self.requestDatasourceExpectation = nil
    }
    
    override func tearDown() {
        super.tearDown()
        self.requestDatasourceExpectation = nil
    }
    
    /// 東京都の「銀座・有楽町・築地」のレストランを検索する（初回取得）
    func test_レストラン検索APIを叩いてレストラン情報50件を取得しマッピングまでするテスト () {
        self.requestDatasourceExpectation = self.expectation(description: "requestDatasource")
        datasource.delegate = self
        datasource.requestDatasource(areaCode: "AREAL2101", offsetPageCount: 1, isAddRequest: false)
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    /// 東京都の「銀座・有楽町・築地」のレストランを検索する（追加取得）
    func test_レストラン検索APIからレストラン情報を追加取得するテスト() {
        self.requestDatasourceExpectation = self.expectation(description: "requestDatasource_first")
        datasource.delegate = self
        datasource.requestDatasource(areaCode: "AREAL2101", offsetPageCount: 1, isAddRequest: false)
        self.waitForExpectations(timeout: 10) { [weak self] error in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else {
                // 待っている間に一つ目の非同期が完了したため、２つ目の非同期処理スタート
                self?.requestDatasourceExpectation = self?.expectation(description: "requestDatasource_additional")
                // 次の処理（追加取得）
                self?.datasource.requestDatasource(areaCode: "AREAL2101", offsetPageCount: 2, isAddRequest: true)
                self?.waitForExpectations(timeout: 10, handler: nil)
            }
        }
    }
    
}

extension RestrantListDatasourceTest: RestrantListDatasourceDelegate {
    
    func receivedDatasource(data: ResrantData) {
        self.requestDatasourceExpectation?.fulfill()
        XCTAssertFalse(data.info.isEmpty)
        XCTAssertTrue(data.info.count == 50)
        XCTAssertTrue(data.hitPage * data.pageOffset == 50)
        XCTAssertNotNil(data.info.first!.name)
        XCTAssertNotNil(data.info.first!.address)
        XCTAssertNotNil(data.info.first!.tel)
        XCTAssertNotNil(data.info.first!.fee)
        XCTAssertNotNil(data.info.first!.imageUrlString.shopUrlstring)
        XCTAssertNotNil(data.info.first!.access.station)
        XCTAssertNotNil(data.info.first!.access.walkTime)
    }
    
    func receivedAdditionalDatasource(data: ResrantData) {
        self.requestDatasourceExpectation?.fulfill()
        XCTAssertFalse(data.info.isEmpty)
        XCTAssertTrue(data.info.count == 50)
        XCTAssertTrue(data.hitPage * data.pageOffset == 100)
        XCTAssertNotNil(data.info.last!.name)
        XCTAssertNotNil(data.info.last!.address)
        XCTAssertNotNil(data.info.last!.tel)
        XCTAssertNotNil(data.info.last!.fee)
        XCTAssertNotNil(data.info.last!.imageUrlString.shopUrlstring)
        XCTAssertNotNil(data.info.last!.access.station)
        XCTAssertNotNil(data.info.last!.access.walkTime)
    }
    
    func receivedErrorResponse(error: Error, isAddRequest: Bool) {
        print("TBD")
    }
    
    func offlineError(isAddRequest: Bool) {
        print("TBD")
    }
    
    func decodeError(error: Error, isAddRequest: Bool) {
        print("TBD")
    }
    
}
