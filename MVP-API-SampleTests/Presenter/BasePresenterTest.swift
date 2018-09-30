//
//  BasePresenterTest.swift
//  MVP-API-SampleTests
//
//  Created by kawaharadai on 2018/10/01.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

@testable import MVP_API_Sample
import XCTest

/// テスト用の空プロトコル（準拠してるかどうかを見るだけ）
protocol TestInterface: class {}

final class BasePresenterTest: XCTestCase, BasePresenter {
    
    weak var interface: TestInterface?
    
    override func setUp() {
        super.setUp()
        destroyInterface()
    }
    
    override func tearDown() {
        super.tearDown()
        destroyInterface()
    }
    
    func test_Viewクラスのinit時にPresenterクラスと参照接続するテスト() {
        let viewClass = TestVC()
        // Presenterクラスを参照
        viewClass.presenter = self
        viewClass.presenter.applyInterface(view: viewClass)
        // Viewクラスを参照できているかどうか
        XCTAssertNotNil(self.interface)
    }
    
}

/// テスト用のViewクラス
final class TestVC: TestInterface {
    var presenter: BasePresenterTest!
}
