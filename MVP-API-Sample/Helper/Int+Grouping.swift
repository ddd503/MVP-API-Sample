//
//  Int+Grouping.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/23.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Foundation

extension Int {
    // ３桁ごとにカンマを入れたStringを返す（３桁以下の場合はStringへの変換のみ）
    var separatorComma: String {
        guard self.description.count > 3 else { return self.description }
        let num = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: num) ?? self.description
    }
}
