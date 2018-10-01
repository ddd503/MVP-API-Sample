//
//  RestrantListDatasource.swift
//  Model
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//
// プロパティとして外部からの参照(される)を保持するためpublicで定義(デリゲートパターン)
// レストラン検索APIへの通信結果
public protocol RestrantListDatasourceDelegate: class {
    func receivedDatasource(data: ResrantData) // データソース取得成功
    func receivedAdditionalDatasource(data: ResrantData) // データソース追加取得成功
    func receivedErrorResponse(error: Error, isAddRequest: Bool) // データソース取得失敗
    func offlineError(isAddRequest: Bool) // オフラインのため通信しない
    func decodeError(error: Error, isAddRequest: Bool) // 受け取ったレスポンスデータのパースに失敗
}

// テスト用に切り出し
protocol RestrantListDatasourceInterface: class {
    /// レストラン検索APIを叩き、レストラン情報を取得する
    ///
    /// - Parameters:
    ///   - areaCode: 検索エリアを指定するコード
    ///   - offsetPageCount: 何ページ目のレスポンスを受け取るか
    func requestDatasource(areaCode: String,
                           offsetPageCount: Int,
                           isAddRequest: Bool)
}

public final class RestrantListDatasource: RestrantListDatasourceInterface {
    /// 外部からinitできるようアクセスレベルをデフォルトからpublicに変更（必須）
    public init() {}
    
    /// Presenterクラスを保持
    public weak var delegate: RestrantListDatasourceDelegate?
    
    public func requestDatasource(areaCode: String, offsetPageCount: Int, isAddRequest: Bool) {
        APIClient.request(option: .searchRestrantAPI(areaCode: areaCode, offsetPageCount: offsetPageCount, recordCount: defaultRecordCount)) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let restrantData = try decoder.decode(ResrantData.self, from: data)
                    if isAddRequest {
                        self.delegate?.receivedAdditionalDatasource(data: restrantData)
                    } else {
                        self.delegate?.receivedDatasource(data: restrantData)
                    }
                } catch let error {
                    if error.isOffline || error.isTimeout {
                        // 通信した結果、オフラインorタイムアウトが返ってきた
                        self.delegate?.offlineError(isAddRequest: isAddRequest)
                        return
                    }
                    self.delegate?.decodeError(error: error, isAddRequest: isAddRequest)
                }
            case .failure(let error):
                self.delegate?.receivedErrorResponse(error: error, isAddRequest: isAddRequest)
            case .doNotRequest:
                self.delegate?.offlineError(isAddRequest: isAddRequest)
            }
        }
    }
    
}
