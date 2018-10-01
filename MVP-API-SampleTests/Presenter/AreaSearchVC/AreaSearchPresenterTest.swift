//
//  AreaSearchPresenterTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/09/23.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import MVP_API_Sample
@testable import Model
import XCTest

final class AreaSearchPresenterTest: XCTestCase {
    
    private let datasource = AreaSeachViewDatasourceMock()
    private var areaSearchPresenterExpectation: XCTestExpectation?

    func test_Modelからのデリゲートを受けるテスト() {
        self.areaSearchPresenterExpectation = self.expectation(description: "AreasearchViewDataSourceDelegateのハンドリング")
        datasource.delegate = self
        // modelへのリクエスト
        datasource.requestDatasource()
        // 指定秒数待つ（非同期処理のテストのため）
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
}

extension AreaSearchPresenterTest: AreaSearchViewDataSourceDelegate {
    
    func receivedDatasource(data: AreaData) {
        self.areaSearchPresenterExpectation?.fulfill()
       XCTAssertTrue(true)
    }
    
}

/// Modelクラスのスタブクラス
final class AreaSeachViewDatasourceMock: AreaSearchViewDatasourceInterface {
   
    var delegate: AreaSearchViewDataSourceDelegate?
    
    /// 空のAreaDataを返す(デリゲート通知を受け取れているかだけを確かめるため問題ない)
    func requestDatasource() {
        guard let delegate = self.delegate else {
            XCTFail("AreaSearchViewDataSourceDelegateが設定されていない")
            return
        }
        let areaData = AreaData(info: [AreaInfo()])
        delegate.receivedDatasource(data: areaData)
    }
    
}
