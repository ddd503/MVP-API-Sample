//
//  AreaData.swift
//  Model
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Foundation

public struct AreaData: Codable {
    public let info: [AreaInfo]
    private enum CodingKeys: String, CodingKey {
        case info = "garea_large"
    }
}

public struct AreaInfo: Codable {
    public init() {} // 外部からのinitを許可
    public var code = ""
    public var name = ""
    public var pref = Pref() // 持ちプロパティに初期値があるからこれでいける
    private enum CodingKeys: String, CodingKey {
        case code = "areacode_l"
        case name = "areaname_l"
        case pref = "pref"
    }
}

public struct Pref: Codable {
    public var code = ""
    public var name = ""
    private enum CodingKeys: String, CodingKey {
        case code = "pref_code"
        case name = "pref_name"
    }
}
