//
//  MenuListViewController.swift
//  coffee
//
//  Created by flexih on 1/19/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import UIKit
import Static
import SnapKit

class MenuListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let v = UITableView(frame: CGRect.zero, style: .plain)
        return v
    }()
    
    let dataSource = DataSource()
    let cityList: CityList
    
    var selectedCity: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.bottom.equalTo(view)
        }
        
        tableView.rowHeight = 50
        tableView.backgroundColor = UIColor(white: 0xFB/255.0, alpha: 1)
        
        dataSource.sections = [Section(rows: cityList.citys.map {
            Row(text: $0.name, selection: { [unowned self] indexPath in
                if let action = self.selectedCity {
                    action(self.cityList.citys[indexPath.row].name)
                    self.dismiss(animated: true, completion: nil)
                }
            }, cellClass: CityCell.self)
        })]
        dataSource.tableView = tableView
    }
    
    init(cityList: CityList) {
        self.cityList = cityList
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
