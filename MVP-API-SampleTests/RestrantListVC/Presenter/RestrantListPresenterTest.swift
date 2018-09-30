//
//  RestrantListPresenterTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/09/24.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import MVP_API_Sample
@testable import Model
import XCTest
import Model

final class RestrantListPresenterTest: XCTestCase, RestrantListPresenterInterface {
   
   private let datasource = RestrantListDatasource()
    private var restrantListPresenterExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_テーブルビューが一番下までスクロールされたかどうかを判定するテスト() {
        var offsetY: CGFloat = 110
        let contentSize: CGFloat = 400
        let height: CGFloat = 300
        XCTAssertTrue(didScrollTableViewToBottom(offsetY: offsetY, contentSize: contentSize, height: height))
        offsetY = 90
        XCTAssertFalse(didScrollTableViewToBottom(offsetY: offsetY, contentSize: contentSize, height: height))
    }
    
    func didScrollTableViewToBottom(offsetY: CGFloat, contentSize: CGFloat, height: CGFloat) -> Bool {
        return offsetY + height > contentSize
    }
    
    func test_APIへの追加取得リクエストが可能かどうかを判定するテスト() {
        let totalHitPageCount = 5000
        var offsetPageCount = 99
        let hitRecordCount = 50
        XCTAssertTrue(isAbleAddRequest(totalHitPageCount: totalHitPageCount, offsetPageCount: offsetPageCount, hitRecordCount: hitRecordCount))
        offsetPageCount = 100
        XCTAssertFalse(isAbleAddRequest(totalHitPageCount: totalHitPageCount, offsetPageCount: offsetPageCount, hitRecordCount: hitRecordCount))
    }
    
    func isAbleAddRequest(totalHitPageCount: Int, offsetPageCount: Int, hitRecordCount: Int) -> Bool {
        return totalHitPageCount > offsetPageCount * hitRecordCount
    }
    
    func test_レストラン検索APIからのレスポンスをハンドリングするテスト() {
        self.restrantListPresenterExpectation = self.expectation(description: "requestDatasource_firstRequest")
        self.datasource.delegate = self
        // 初回表示時のAPIアクセス
        self.datasource.requestDatasource(areaCode: "AREAL2101", offsetPageCount: 1, isAddRequest: false)
        // 完了宣言後走る
        self.waitForExpectations(timeout: 10) { [weak self] error in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else {
                self?.restrantListPresenterExpectation = self?.expectation(description: "requestDatasource_additionalRequest")
                self?.datasource.requestDatasource(areaCode: "AREAL2101", offsetPageCount: 2, isAddRequest: true)
                self?.waitForExpectations(timeout: 10, handler: nil)
            }
        }
    }
    
}

extension RestrantListPresenterTest: RestrantListDatasourceDelegate {
    
    func receivedDatasource(data: ResrantData) {
        self.restrantListPresenterExpectation?.fulfill()
        XCTAssertNotNil(data.info)
    }
    
    func receivedAdditionalDatasource(data: ResrantData) {
        self.restrantListPresenterExpectation?.fulfill()
        XCTAssertNotNil(data.info)
    }
    
    func receivedErrorResponse(error: Error, isAddRequest: Bool) {
        XCTAssert(true)
    }
    
    func offlineError(isAddRequest: Bool) {
        XCTAssert(true)
    }
    
    func decodeError(error: Error, isAddRequest: Bool) {
        XCTAssert(true)
    }
    
}
