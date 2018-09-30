//
//  ViewControllerBuilder.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/29.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class ViewControllerBuilder {
    
    /// エリア選択画面
    static func buildAreaSeachVC() -> AreaSeachViewController {
        let vcName = "AreaSeachViewController"
        let vc = UIStoryboard(name: vcName, bundle: Bundle.main).instantiateViewController(withIdentifier: vcName) as! AreaSeachViewController
        vc.presenter = AreaSearchPresenter()
        // PresenterクラスにViewクラスを参照させる
        vc.presenter.applyInterface(view: vc)
        return vc
    }
    
    /// レストラン一覧画面
    /// - Parameter areaInfo: 検索するエリア情報
    static func buildRestrantListVC(areaSearchPresenter: AreaSearchPresenter, indexPathRow: Int) -> RestrantListViewController {
        let vcName = "RestrantListViewController"
        let vc = UIStoryboard(name: vcName, bundle: Bundle.main).instantiateViewController(withIdentifier: vcName) as! RestrantListViewController
        vc.presenter = RestrantListPresenter()
        // PresenterクラスにViewクラスを参照させる
        vc.presenter.applyInterface(view: vc)
        vc.presenter.areaInfo = areaSearchPresenter.areaList[indexPathRow]
        return vc
    }
    
    /// 表示中の画面(UIViewController)を取得する（最前面）
    ///
    /// - Returns: 表示中の画面(失敗した場合はnilを返す)
    static func topVC() -> UIViewController? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var topViewController = rootViewController
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            return topViewController
        } else {
            return nil
        }
    }
    
}

