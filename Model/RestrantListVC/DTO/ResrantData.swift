//
//  ResrantData.swift
//  Model
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//


import Foundation

public struct ResrantData: Codable {
    public let info: [RestrantInfo]
    public let totalHitCount: Int
    public let pageOffset: Int
    public let hitPage: Int
    private enum CodingKeys: String, CodingKey {
        case info = "rest"
        case totalHitCount = "total_hit_count"
        case pageOffset = "page_offset"
        case hitPage = "hit_per_page"
    }
}

public struct RestrantInfo: Codable {
    public let name: String
    public let address: String
    public let tel: String
    public let fee: Int
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
    public let shopUrlstring: String
    private enum CodingKeys: String, CodingKey {
        case shopUrlstring = "shop_image1"
    }
}

public struct Access: Codable {
    public let station: String
    public let walkTime: String
    private enum CodingKeys: String, CodingKey {
        case station = "station"
        case walkTime = "walk"
    }
}
