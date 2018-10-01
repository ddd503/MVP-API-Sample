//
//  ResrantData.swift
//  Model
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//


import Foundation

public struct ResrantData: Codable {
    public var info: [RestrantInfo] = []
    public var totalHitCount = 0
    public var pageOffset = 0
    public var hitPage = 0
    private enum CodingKeys: String, CodingKey {
        case info = "rest"
        case totalHitCount = "total_hit_count"
        case pageOffset = "page_offset"
        case hitPage = "hit_per_page"
    }
}

public struct RestrantInfo: Codable {
    public var name = ""
    public var address = ""
    public var tel = ""
    public var fee = 0
    public let imageUrlString: ImageUrl
    public let access: Access
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case address = "address"
        case tel = "tel"
        case fee = "budget"
        case imageUrlString = "image_url"
        case access = "access"
    }
}

public struct ImageUrl: Codable {
    public var shopUrlstring = ""
    private enum CodingKeys: String, CodingKey {
        case shopUrlstring = "shop_image1"
    }
}

public struct Access: Codable {
    public var station = ""
    public var walkTime = ""
    private enum CodingKeys: String, CodingKey {
        case station = "station"
        case walkTime = "walk"
    }
}
