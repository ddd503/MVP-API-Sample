//
//  UIAlertController+Present.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/23.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

extension UIAlertController {
    /// 表示中の画面にアラートを出す
    func present() {
        if let topViewController = ViewControllerManager.getTopViewController() {
            // 二重表示防止のため、最前面がAlertの場合はreturnする
            guard !(topViewController is UIAlertController) else { return }
            topViewController.present(self, animated: true)
        }
    }
}
