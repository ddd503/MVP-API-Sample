//
//  AreaSearchPresenterTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/09/23.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import MVP_API_Sample
import XCTest

final class AreaSearchPresenterTest: XCTestCase {
    
    private var areaSearchPresenterExpectation: XCTestExpectation?
    private let datasource = AreaSearchViewDatasource()
    
    override func setUp() {
        super.setUp()
        self.areaSearchPresenterExpectation = nil
    }
    
    override func tearDown() {
        super.tearDown()
        self.areaSearchPresenterExpectation = nil
    }

    func test_Modelから受け取ったエリア情報から表示する情報のみマッピングするテスト() {
        self.datasource.delegate = self
        // modelへのリクエスト
        self.areaSearchPresenterExpectation = self.expectation(description: "AreasearchViewDataSourceDelegate_handler")
        self.datasource.requestDatasource()
        // 指定秒数待つ（非同期処理のため）
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
}

extension AreaSearchPresenterTest: AreaSearchViewDataSourceDelegate {
    
    func receivedDatasource(data: AreaData) {
        // 監視完了(判定が可能となる)
        self.areaSearchPresenterExpectation?.fulfill()
        let tokyoAreaList = getTargetAreaList(areaData: data)
        XCTAssertFalse(tokyoAreaList.isEmpty)
        XCTAssertTrue(tokyoAreaList.first?.pref.name == "東京都")
        let kyotoAreaList = getTargetAreaList(areaData: data, areaName: "京都府")
        XCTAssertFalse(kyotoAreaList.isEmpty)
        XCTAssertTrue(kyotoAreaList.first?.pref.name == "京都府")
        let hogeAreaList = getTargetAreaList(areaData: data, areaName: "hoge")
        XCTAssertTrue(hogeAreaList.isEmpty)
    }
    
}
