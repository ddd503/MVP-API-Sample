//
//  RestrantListPresenter.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import CoreGraphics

protocol RestrantListInterface: class {
    /// 画面更新
    func reload()
    /// 追加取得
    func addRequestApi()
    /// エラー表示
    func errorAlert(message: String, completionHandler: ((Any) -> ())?)
    /// インジケーターの表示非表示
    func updateIndicator(isHidden: Bool)
    /// ナビバータイトルの更新
    func updateTitle(title: String)
    /// 前画面に戻る
    func dismiss()
}

protocol RestrantListPresenterInterface: class {
    /// テーブルビューの一番下までスクロールしたかどうか
    ///
    /// - Parameters:
    ///   - offsetY: tableView内のscrollViewのy軸のoffset
    ///   - contentSize: tableView内のscrollViewのcontentSize
    ///   - height: tableViewの縦幅
    /// - Returns: テーブルビューの一番下までスクロールしたか
    func didScrollTableViewToBottom(offsetY: CGFloat,
                                    contentSize: CGFloat,
                                    height: CGFloat) -> Bool
    /// 追加取得できるかどうか
    ///
    /// - Parameters:
    ///   - totalHitPageCount: 全該当件数
    ///   - offsetPageCount: 表示ページ数
    ///   - hitRecordCount: 1ページあたりの表示件数
    /// - Returns: 追加取得が可能かどうか
    func isAbleAddRequest(totalHitPageCount: Int,
                          offsetPageCount: Int,
                          hitRecordCount: Int) -> Bool
}

final class RestrantListPresenter: BasePresenter, RestrantListPresenterInterface {
    /// アクセスするModelクラス
    private let datasource = RestrantListDatasource()
    /// Viewクラスから受けたアクションをハンドリングするインターフェース（VCを参照している）
    weak var interface: RestrantListInterface?
    /// データソース保持用、データ更新に合わせて画面を更新する
    private (set) var restrantList = [RestrantInfo]()
    // API関連パラメータの管理
    var areaInfo = AreaInfo()
    private var offsetPageCount = 1
    private var hitRecordCount = 0
    private var totalHitPageCount = 0 {
        didSet {
            if !areaInfo.name.isEmpty {
                self.interface?.updateTitle(title: "\(areaInfo.name)の飲食店 \(totalHitPageCount.separatorComma)件")
            }
        }
    }
    // APIリクエスト状況
    private var isLoading = false
    
    /// 初期化処理
    init() {
        self.datasource.delegate = self
    }
    
    /// APIリクエスト
    func requestDatasource() {
        self.isLoading = true
        self.datasource.requestDatasource(areaCode: areaInfo.code,
                                          offsetPageCount: offsetPageCount,
                                          isAddRequest: false)
    }
    
    /// API追加リクエスト
    func requestAddDatasource() {
        self.isLoading = true
        self.updateAddRequestIndicatorStatus(isHidden: false)
        self.addOffsetPageCount()
        self.datasource.requestDatasource(areaCode: areaInfo.code,
                                          offsetPageCount: offsetPageCount,
                                          isAddRequest: true)
    }
    
    /// 検索開始ページ位置を更新する（追加）
    private func addOffsetPageCount() {
        self.offsetPageCount += 1
    }
    
    /// レストラン検索APIへのリクエスト状況をプロパティに保持させる
    ///
    /// - Parameter data: レストラン情報
    private func updateCount(data: ResrantData) {
        self.offsetPageCount = data.pageOffset
        self.hitRecordCount = data.hitPage
        self.totalHitPageCount = data.totalHitCount
    }
    
    /// 以下の条件の場合追加取得を行う
    ///
    /// テーブルビューの一番下までスクロールした & 別途追加取得処理をしていない & スワイプ中 & サーバーに追加取得できるデータが残っている
    func didScrollTableView(offsetY: CGFloat,
                            contentSize: CGFloat,
                            height: CGFloat,
                            isDragging: Bool) {
        if didScrollTableViewToBottom(offsetY: offsetY,
                                       contentSize: contentSize,
                                       height: height),
            isAbleAddRequest(totalHitPageCount: self.totalHitPageCount,
                             offsetPageCount: self.offsetPageCount,
                             hitRecordCount: self.hitRecordCount),
            isDragging,
            isLoading == false {
            // 追加取得実行
            self.interface?.addRequestApi()
        }
    }
    
    func didScrollTableViewToBottom(offsetY: CGFloat,
                                    contentSize: CGFloat,
                                    height: CGFloat) -> Bool {
        return offsetY + height > contentSize
    }
    
    func isAbleAddRequest(totalHitPageCount: Int,
                          offsetPageCount: Int,
                          hitRecordCount: Int) -> Bool {
        return totalHitPageCount > offsetPageCount * hitRecordCount
    }
    
    /// インジケーターの表示非表示を切り替える
    ///
    /// - Parameter isHidden: true 非表示, false 表示
    private func updateAddRequestIndicatorStatus(isHidden: Bool) {
        self.interface?.updateIndicator(isHidden: isHidden)
    }
    
}

extension RestrantListPresenter: RestrantListDatasourceDelegate {
    
    func receivedDatasource(data: ResrantData) {
        self.isLoading = false
        self.updateCount(data: data)
        self.restrantList.append(contentsOf: data.info)
        self.interface?.reload()
    }
    
    func receivedAdditionalDatasource(data: ResrantData) {
        self.isLoading = false
        self.updateCount(data: data)
        self.restrantList.append(contentsOf: data.info)
        self.updateAddRequestIndicatorStatus(isHidden: true)
        self.interface?.reload()
    }
    
    func receivedErrorResponse(error: Error, isAddRequest: Bool) {
        self.updateAddRequestIndicatorStatus(isHidden: true)
        // 初回取得時のエラー以外は無視（アラート自体出さない）
        if !isAddRequest {
            self.interface?.errorAlert(message: "店舗情報の取得に失敗しました。") { [weak self] _ in
                self?.isLoading = false
                self?.interface?.dismiss()
            }
        }
    }
    
    func offlineError(isAddRequest: Bool) {
        self.updateAddRequestIndicatorStatus(isHidden: true)
        // アラート表示は確定
        self.interface?.errorAlert(message: "通信環境が良い場所で再度お試しください。") { [weak self] _ in
            self?.isLoading = false
            isAddRequest ? nil : self?.interface?.dismiss()
        }
    }
    
    func decodeError(error: Error, isAddRequest: Bool) {
        self.updateAddRequestIndicatorStatus(isHidden: true)
        // 初回取得時のエラー以外は無視（アラート自体出さない）
        if !isAddRequest {
            self.interface?.errorAlert(message: "店舗情報の取得に失敗しました。") { [weak self] _ in
                self?.isLoading = false
                self?.interface?.dismiss()
            }
        }
    }
    
}
