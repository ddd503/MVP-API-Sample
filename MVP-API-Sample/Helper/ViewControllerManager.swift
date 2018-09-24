//
//  ViewControllerManager.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/23.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class ViewControllerManager {
    /// 表示中の画面(UIViewController)を取得する（最前面）
    ///
    /// - Returns: 表示中の画面(失敗した場合はnilを返す)
    static func getTopViewController() -> UIViewController? {
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
