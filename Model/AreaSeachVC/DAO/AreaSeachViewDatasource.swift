//
//  AreaSeachViewDatasource.swift
//  Model
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Foundation

// プロパティとして外部からの参照(される)を保持するためpublicで定義(デリゲートパターン)
public protocol AreaSearchViewDataSourceDelegate: class {
    /// 取得したエリアデータを返す
    ///
    /// - Parameter data: 取得したエリアデータ
    func receivedDatasource(data: AreaData)
}

// テスト用に切り出し
protocol AreaSearchViewDatasourceInterface: class {
    /// データソースを取得する
    func requestDatasource()
}

public final class AreaSearchViewDatasource: AreaSearchViewDatasourceInterface {
    /// 外部からinitできるようアクセスレベルをデフォルトからpublicに変更（必須）
    public init() {}
    
    public var delegate: AreaSearchViewDataSourceDelegate?
    
    /// ローカルのJSONファイルからエリアデータを取得し、マッピングしたレスポンスを返す
    public func requestDatasource() {
        guard let filePath = self.getLocalJsonFilePath(fileName: "area") else {
            fatalError("json is not found in main Bundle.")
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let decoder = JSONDecoder()
            let areaData = try decoder.decode(AreaData.self, from: jsonData)
            self.delegate?.receivedDatasource(data: areaData)
        } catch {
            fatalError("failuer in codable session")
        }
    }
    
    /// lacalのjsonファイルのpathを取得
    ///
    /// - Parameter fileName: ファイル名
    /// - Returns: jsonファイルのpath(失敗の場合はnil)
    func getLocalJsonFilePath(fileName: String) -> String? {
        return Bundle.main.path(forResource: fileName, ofType: "json")
    }
    
}
