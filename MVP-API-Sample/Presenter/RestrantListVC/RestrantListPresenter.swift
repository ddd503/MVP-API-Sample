//
//  RestrantListPresenter.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import CoreGraphics
import Model

protocol RestrantListInterface: class {
    /// 画面更新
    func reload()
    /// 追加取得
    func addRequestApi()
    /// エラー表示
    func errorAlert(message: String, completionHandler: ((Any) -> ())?)
    /// 取得時のインジケーターの表示開始(ライブラリ仕様)
    func startIndicator()
    /// 取得時のインジケーターの表示終了(ライブラリ仕様)
    func stopIndicator()
    /// 追加取得インジケーターの表示非表示
    func updateAdditionalIndicator(isHidden: Bool)
    /// ナビバータイトルの更新
    func updateTitle(title: String)
    /// 前画面に戻る
    func dismiss()
}

/// テスト用に切り出し
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
    /// Viewクラスから受けたアクションをハンドリングするインターフェース（VCを参照しているためweakにする）
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
    
    /// presenter側のViewインスタンスの破棄
    deinit {
        destroyInterface()
    }
    
    /// APIリクエスト
    func requestDatasource() {
        self.isLoading = true
        self.interface?.startIndicator()
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
        self.interface?.updateAdditionalIndicator(isHidden: isHidden)
    }
    
    /// セルにモデルクラスの情報を引き渡す
    ///
    /// - Parameters:
    ///   - cell: 表示するセル
    ///   - indexPath: セルのindexPath
    func setupTableViewCell(cell: RestrantInfoCell, indexPath: IndexPath) {
        cell.nameLabel.text = restrantList[indexPath.row].name
        cell.stationLabel.text = restrantList[indexPath.row].access.station
        cell.walkLabel.text = "\(restrantList[indexPath.row].access.walkTime)分"
        cell.addressLabel.text = restrantList[indexPath.row].address
        cell.telLabel.text = restrantList[indexPath.row].tel
        cell.feeLabel.text = "¥\(restrantList[indexPath.row].fee.separatorComma)"
        /// セル側でKingfisherをimportしている
        if let url = URL(string: restrantList[indexPath.row].imageUrlString.shopUrlstring) {
            cell.shotImageView.kf.setImage(with: url, placeholder: UIImage(named: "no_image"))
        }
    }
    
}

extension RestrantListPresenter: RestrantListDatasourceDelegate {
    
    func receivedDatasource(data: ResrantData) {
        self.isLoading = false
        self.updateCount(data: data)
        self.restrantList.append(contentsOf: data.info)
        self.interface?.reload()
        self.interface?.stopIndicator()
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
                self?.interface?.stopIndicator()
                self?.interface?.dismiss()
            }
        }
    }
    
    func offlineError(isAddRequest: Bool) {
        self.updateAddRequestIndicatorStatus(isHidden: true)
        // 初回取得時のみそれ用のインジケーターを止める
        isAddRequest ? nil : self.interface?.stopIndicator()
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
                self?.interface?.stopIndicator()
                self?.interface?.dismiss()
            }
        }
    }
    
}
