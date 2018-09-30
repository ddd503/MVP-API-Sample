//
//  AreaSearchPresenter.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Model

protocol AreaListInterface: class {
    /// 画面更新
    func reload()
    /// レストラン検索ページに遷移する
    ///
    /// - Parameter restVC: レストラン検索結果を表示するVC
    func transitionToRestrantSearchVC(restVC: RestrantListViewController)
}

final class AreaSearchPresenter: BasePresenter {
    /// アクセスするModelクラス
    private let datasource = AreaSearchViewDatasource()
    /// Viewクラスから受けたアクションをハンドリングするインターフェース（VCを参照しているためweakにする）
    weak var interface: AreaListInterface?
    /// データソース保持用、データ更新に合わせて画面を更新する
    private (set) var areaList = [AreaInfo]() {
        didSet {
            self.interface?.reload()
        }
    }
    
    /// 初期化処理
    init() {
        self.datasource.delegate = self
    }
    
    /// presenter側のViewインスタンスの破棄
    deinit {
        destroyInterface()
    }
    
    /// API通信処理を呼び出す
    func requestDataSource() {
        self.datasource.requestDatasource()
    }
    
    /// テーブルビューのセルタップアクションをハンドリング
    ///
    /// - Parameter row: タップしたセルのindex
    func didSelectAreaData(row: Int) {
        self.interface?.transitionToRestrantSearchVC(restVC: ViewControllerBuilder.buildRestrantListVC(areaSearchPresenter: self, indexPathRow: row))
    }
    
}

extension AreaSearchPresenter: AreaSearchViewDataSourceDelegate {
    
    func receivedDatasource(data: AreaData) {
        // 狙ったエリアのみ取り出す（東京以外を取り出す場合は引き数で渡す）
        self.areaList.append(contentsOf: getTargetAreaList(areaData: data))
    }
    
}

// デフォルト引数を持たせてみる
extension AreaSearchViewDataSourceDelegate {
    
    /// 表示するエリアデータのみ抽出する
    ///
    /// - Parameters:
    ///   - areaData: 取得したエリアデータ
    ///   - areaName: 抽出するエリアデータ名
    /// - Returns: areaNameで絞り込みをかけたAreaInfoの配列
    func getTargetAreaList(areaData: AreaData, areaName: String = "東京都") -> [AreaInfo] {
        return areaData.info.filter {
            $0.pref.name == areaName
        }
    }
    
}
