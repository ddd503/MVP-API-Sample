//
//  RestrantListViewController.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class RestrantListViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var restrantListTableView: UITableView! {
        didSet {
            // テーブルビューの各種設定
            restrantListTableView.delegate = self
            restrantListTableView.dataSource = self
            restrantListTableView.register(UINib(nibName: RestrantInfoCell.identifier, bundle: nil),
                                           forCellReuseIdentifier: RestrantInfoCell.identifier)
            restrantListTableView.register(UINib(nibName: ReloadView.identifier, bundle: nil),
                                           forCellReuseIdentifier: ReloadView.identifier)
            
            if let reloadView = restrantListTableView.dequeueReusableCell(withIdentifier: ReloadView.identifier) as? ReloadView {
                reloadView.indicator.isHidden = true
                restrantListTableView.tableFooterView = reloadView
                restrantListTableView.tableFooterView?.frame.size.height = 0
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var presenter: RestrantListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.requestDatasource()
    }
    
}

extension RestrantListViewController: RestrantListInterface {
    
    /// 画面更新
    func reload() {
        self.restrantListTableView.reloadData()
    }
    
    /// 追加取得
    func addRequestApi() {
        self.presenter.requestAddDatasource()
    }
    
    /// エラーアラートを表示する
    ///
    /// - Parameters:
    ///   - message: "表示メッセージ"
    ///   - completionHandler: アラートタップ時のアクション（デフォルトはnil）
    func errorAlert(message: String, completionHandler: ((Any) -> ())?) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: completionHandler)
        alert.addAction(alertAction)
        alert.present()
    }
    
    /// 初回取得時用のインジケーターのアニメーション開始
    func startIndicator() {
        startAnimating(message: "データ取得中", type: .pacman)
    }
    
    /// 初回取得時用のインジケーターのアニメーション終了
    func stopIndicator() {
        stopAnimating()
    }
    
    /// 追加取得インジケーター表示の変更
    func updateAdditionalIndicator(isHidden: Bool) {
        // あえて強制アンラップ(失敗時にクラッシュさせたい)
        let reloadView = self.restrantListTableView.tableFooterView as! ReloadView
        reloadView.indicator.isHidden = isHidden
        reloadView.frame.size.height = isHidden ? 0 : 50
    }
    
    /// タイトルの更新
    func updateTitle(title: String) {
        self.navigationItem.title = title
    }
    
    /// 前の画面に戻る
    func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RestrantListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.restrantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestrantInfoCell.identifier, for: indexPath) as? RestrantInfoCell else {
            fatalError("cell is nil")
        }
//        cell.setInfo(info: self.presenter.restrantList[indexPath.row])
        presenter.setupTableViewCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
}

extension RestrantListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.presenter.didScrollTableView(offsetY: scrollView.contentOffset.y,
                                          contentSize: scrollView.contentSize.height,
                                          height: scrollView.frame.size.height,
                                          isDragging: scrollView.isDragging)
    }
    
}
