//
//  BasePresenter.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/29.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

protocol BasePresenter: class {
     // それぞれの準拠元で柔軟的に型を決定できる値
    associatedtype ViewObject
    // Presenterクラス側でViewクラスを保持する用propatie
    // デフォルト実装で、自動的に渡されたViewクラスをPresenterクラスのinterface変数(protcol)にセットする
    var interface: ViewObject? { get set }
    
    func applyInterface(view: ViewObject)
}

extension BasePresenter {
    /// Presenterクラス側で状態を管理するViewクラスを設定する(今回はデフォルト実装で共通化)
    ///
    /// - Parameter view: viewクラス
    func applyInterface(view: ViewObject) {
        interface = view
    }
}
