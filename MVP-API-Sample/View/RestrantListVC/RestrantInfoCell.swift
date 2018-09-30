//
//  RestrantInfoCell.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit
import Kingfisher

final class RestrantInfoCell: UITableViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shotImageView.image = nil
    }
    
}
