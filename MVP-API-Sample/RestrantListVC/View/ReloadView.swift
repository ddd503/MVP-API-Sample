//
//  ReloadView.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

class ReloadView: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
