//
//  RestrantListPresenterTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/09/24.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import MVP_API_Sample
import XCTest

final class RestrantListPresenterTest: XCTestCase, RestrantListPresenterInterface {
   
    let datasource = RestrantListDatasource()
    
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
    
}
