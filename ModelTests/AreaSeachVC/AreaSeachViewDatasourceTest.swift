//
//  AreaSeachViewDatasourceTest.swift
//  ModelTests
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Model
import XCTest

final class AreaSeachViewDatasourceTest: XCTestCase {
    
    func test_ローカルのJSONファイルからエリアデータを取得してAreaDataモデルにマッピングするテスト() {
        guard let filePath = getLocalJsonFilePathFromTestPJ(fileName: "area_test") else {
            XCTFail()
            return
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            XCTAssertNotNil(jsonData)
            let decoder = JSONDecoder()
            let areaData = try decoder.decode(AreaData.self, from: jsonData)
            XCTAssertNotNil(areaData.info)
            XCTAssertEqual(areaData.info.first?.code, "AREAL5500")
            XCTAssertEqual(areaData.info.first?.name, "札幌駅・大通・すすきの")
            XCTAssertEqual(areaData.info.first?.pref.code, "PREF01")
            XCTAssertEqual(areaData.info.first?.pref.name, "北海道")
        } catch {
            XCTFail()
        }
    }
    
    /// TestProjectに置いてあるlacalのjsonファイルのpathを取得
    ///
    /// - Parameter fileName: ファイル名
    /// - Returns: jsonファイルのpath(失敗の場合はnil)
    func getLocalJsonFilePathFromTestPJ(fileName: String) -> String? {
        return Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json")
    }
    
}
