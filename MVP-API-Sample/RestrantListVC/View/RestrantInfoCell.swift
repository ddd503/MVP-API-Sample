//
//  RestrantInfoCell.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Kingfisher
import UIKit

class RestrantInfoCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var walkLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var shotImageView: UIImageView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setInfo(info: RestrantInfo) {
        self.nameLabel.text = info.name
        self.stationLabel.text = info.access.station
        self.walkLabel.text = "\(info.access.walkTime)分"
        self.addressLabel.text = info.address
        self.telLabel.text = info.tel
        self.feeLabel.text = "¥\(info.fee.separatorComma)"
        if let url = URL(string: info.imageUrlString.shopUrlstring) {
            self.shotImageView.kf.setImage(with: url, placeholder: UIImage(named: "no_image"))
        }
    }
}
