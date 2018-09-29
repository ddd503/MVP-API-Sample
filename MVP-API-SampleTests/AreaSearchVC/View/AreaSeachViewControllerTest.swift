//
//  AreaSeachViewControllerTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/09/28.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import MVP_API_Sample
import XCTest

class AreaSeachViewControllerTest: XCTestCase {
    
    private var presenter: AreaSearchPresenter!
    
    override func setUp() {
        super.setUp()
       
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
   
}

extension AreaSeachViewControllerTest: AreaListInterface {
    
    func reload() {
        <#code#>
    }
    
    func transitionToRestrantSearchVC(areaInfo: AreaInfo) {
        <#code#>
    }
    
}
