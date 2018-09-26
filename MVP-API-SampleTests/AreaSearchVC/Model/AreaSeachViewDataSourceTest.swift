//
//  AreaSeachViewDataSourceTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/09/23.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import MVP_API_Sample
import XCTest

final class AreaSeachViewDataSourceTest: XCTestCase {
    
    private var requestDatasourceExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        self.requestDatasourceExpectation = nil
    }
    
    override func tearDown() {
        super.tearDown()
        self.requestDatasourceExpectation = nil
    }
    
    func testr_API通信を行ってレスポンスをマッピングするテスト() {
        self.requestDatasourceExpectation = self.expectation(description: "AreasearchViewDataSourceDelegate")
        let datasource = AreaSearchViewDatasource()
        datasource.delegate = self
        datasource.requestDatasource()
        // 指定秒数待つ（非同期処理のため）
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_localに置いたjsonファイルのpathを取得するテスト() {
        let datasource = AreaSearchViewDatasource()
        XCTAssertNotNil(datasource.getLocalJsonFilePath(fileName: "area"))
        XCTAssertNil(datasource.getLocalJsonFilePath(fileName: "hoge"))
    }
    
}

extension AreaSeachViewDataSourceTest: AreaSearchViewDataSourceDelegate {
    
    func receivedDatasource(data: AreaData) {
        // 監視完了(判定が可能となる)
        self.requestDatasourceExpectation?.fulfill()
        XCTAssertNotNil(data)
        XCTAssertNotNil(data.info)
        XCTAssertNotNil(data.info.first?.code)
        XCTAssertNotNil(data.info.first?.name)
        XCTAssertNotNil(data.info.first?.pref)
        XCTAssertNotNil(data.info.first?.pref.code)
        XCTAssertNotNil(data.info.first?.pref.name)
    }
    
}
