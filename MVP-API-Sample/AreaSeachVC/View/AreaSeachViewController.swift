//
//  AreaSeachViewController.swift
//  MVP-API-Sample
//
//  Created by kawaharadai on 2018/09/22.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class AreaSeachViewController: UIViewController {
    
    @IBOutlet weak var areaListTableView: UITableView! {
        didSet {
            areaListTableView.dataSource = self
            areaListTableView.delegate = self
        }
    }
    
    var presenter: AreaSearchPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = self.initPresenter(vc: self)
        self.presenter.requestDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = areaListTableView.indexPathForSelectedRow {
            areaListTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    /// Presenterを用意（presenter側のデリゲートを受け取るためVCを渡す）
    ///
    /// - Parameter vc: AreaListInterfaceに準拠したVC
    func initPresenter(vc: AreaListInterface) -> AreaSearchPresenter {
        return AreaSearchPresenter(areaListInterface: vc)
    }
    
}

extension AreaSeachViewController: AreaListInterface {
    
    /// 画面更新
    func reload() {
        self.areaListTableView.reloadData()
    }
    
    /// レストラン一覧を取得する画面へ遷移する
    ///
    /// - Parameter areaInfo: レストラン一覧取得に必要な情報
    func transitionToRestrantSearchVC(areaInfo: AreaInfo) {
        guard let restrantListViewController = UIStoryboard(name: "RestrantListViewController", bundle: nil)
            .instantiateInitialViewController() as? RestrantListViewController else {
                return
        }
        restrantListViewController.initPresenter(areaInfo: areaInfo)
        self.navigationController?.pushViewController(restrantListViewController, animated: true)
    }
    
}

extension AreaSeachViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.areaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.presenter.areaList[indexPath.row].name
        return cell
    }
    
}

extension AreaSeachViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectAreaData(row: indexPath.row)
    }
    
}
