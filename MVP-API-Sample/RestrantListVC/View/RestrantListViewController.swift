//
//  RestrantListViewController.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class RestrantListViewController: UIViewController {
    
    @IBOutlet weak var restrantListTableView: UITableView! {
        didSet {
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
    
    func initPresenter(areaInfo: AreaInfo) {
        self.presenter = RestrantListPresenter(interface: self)
        self.presenter.areaCode = areaInfo.code
        self.presenter.areaName = areaInfo.name
    }
    
}

extension RestrantListViewController: RestrantListInterface {
    
    // 画面更新
    func reload() {
        self.restrantListTableView.reloadData()
    }
    
    // 追加取得
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
    
    // インジケーター表示の変更
    func updateIndicator(isHidden: Bool) {
        // あえて強制アンラップ(失敗時にクラッシュさせたい)
        let reloadView = self.restrantListTableView.tableFooterView as! ReloadView
        reloadView.indicator.isHidden = isHidden
        reloadView.frame.size.height = isHidden ? 0 : 50
    }
    
    // タイトルの更新
    func updateTitle(title: String) {
        self.navigationItem.title = title
    }
    
    // 前の画面に戻る
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
        cell.setInfo(info: self.presenter.restrantList[indexPath.row])
        return cell
    }
    
}

extension RestrantListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.presenter.didScrollTableView(offsetY: self.restrantListTableView.contentOffset.y,
                                          contentSize: self.restrantListTableView.contentSize.height,
                                          height: self.restrantListTableView.frame.size.height,
                                          isDragging: self.restrantListTableView.isDragging)
    }
    
}
