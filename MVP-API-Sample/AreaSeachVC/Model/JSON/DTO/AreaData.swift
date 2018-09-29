//
//  AreaData.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Foundation

struct AreaData: Codable {
    let info: [AreaInfo]
    private enum CodingKeys: String, CodingKey {
        case info = "garea_large"
    }
}

struct AreaInfo: Codable {
    var code = ""
    var name = ""
    var pref = Pref() // 持ちプロパティに初期値があるからこれでいける
    private enum CodingKeys: String, CodingKey {
        case code = "areacode_l"
        case name = "areaname_l"
        case pref = "pref"
    }
}

struct Pref: Codable {
    var code = ""
    var name = ""
    private enum CodingKeys: String, CodingKey {
        case code = "pref_code"
        case name = "pref_name"
    }
}
