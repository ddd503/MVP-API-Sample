//
//  ResrantData.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Foundation

struct ResrantData: Codable {
    let info: [RestrantInfo]
    let totalHitCount: Int
    let pageOffset: Int
    let hitPage: Int
    private enum CodingKeys: String, CodingKey {
        case info = "rest"
        case totalHitCount = "total_hit_count"
        case pageOffset = "page_offset"
        case hitPage = "hit_per_page"
    }
}

struct RestrantInfo: Codable {
    let name: String
    let address: String
    let tel: String
    let fee: Int
    let imageUrlString: ImageUrl
    let access: Access
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case address = "address"
        case tel = "tel"
        case fee = "budget"
        case imageUrlString = "image_url"
        case access = "access"
    }
}

struct ImageUrl: Codable {
    let shopUrlstring: String
    private enum CodingKeys: String, CodingKey {
        case shopUrlstring = "shop_image1"
    }
}

struct Access: Codable {
    let station: String
    let walkTime: String
    private enum CodingKeys: String, CodingKey {
        case station = "station"
        case walkTime = "walk"
    }
}
