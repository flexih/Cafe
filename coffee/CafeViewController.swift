//
//  CafeViewController.swift
//  coffee
//
//  Created by flexih on 1/8/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import UIKit
import Static
import SnapKit
import AlamofireImage

class CafeViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let v = UITableView(frame: CGRect.zero, style: .plain)
        return v
    }()
    
    let posterViewHeight: CGFloat = 255
    let dataSource = DataSource()
    let cafe: Cafe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.bottom.equalTo(view)
        }
        
        title = cafe.name
        
        posterView.frame = CGRect(x: 0, y: -posterViewHeight, width: view.bounds.width, height: posterViewHeight)
        posterView.af_setImage(withURL: cafe.posterURL, placeholderImage: nil, filter: ScaledToSizeFilter(size: posterView.bounds.size))
        posterView.contentMode = .scaleAspectFill
        posterView.clipsToBounds = true
        tableView.addSubview(posterView)
        tableView.contentInset = UIEdgeInsets(top: posterView.bounds.height, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 70
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        
        var rows = [Row]()
        
        if let phone = cafe.phones?.joined(separator: ", ") {
            rows.append(Row(text: "电话", detailText: phone, selection: { [weak self] indexPath in
                if let this = self {
                    this.alertDail(this.cafe.phones!)
                }
            }, cellClass: CafeInfoCell.self))
        }
        
        rows.append(Row(text: "地址", detailText: cafe.addr, cellClass: CafeInfoCell.self))
        
        if let openingTime = cafe.openingTime {
            rows.append(Row(text: "营业时间", detailText: openingTime, cellClass: CafeInfoCell.self))
        }
        
        if let other = cafe.remarks {
            rows.append(Row(text: "其他", detailText: other, cellClass: CafeInfoCell.self))
        }
        
        dataSource.sections = [Section(rows: rows)]
        dataSource.tableView = tableView
        
        tableView.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let offset = tableView.contentOffset;
            var frame = posterView.frame;
            
            if offset.y + tableView.contentInset.top < 0 {
                frame.origin.y = offset.y + 64
                frame.size.height = fabs(offset.y) - tableView.contentInset.top + posterViewHeight
            } else {
                frame.origin.y = -posterViewHeight
                frame.size.height = posterViewHeight
            }
            
            posterView.frame = frame;
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(cafe: Cafe) {
        self.cafe = cafe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var posterView: UIImageView = {
        let v = UIImageView()
        let blurView = UIView()
        let label = UILabel()
        
        guard self.cafe.oneword?.isEmpty == false else {
            return v
        }
        
        blurView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.text = self.cafe.oneword
        let size = label.sizeThatFits(CGSize(width: self.view.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude))
        
        v.addSubview(blurView)
        blurView.addSubview(label)
        
        blurView.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(size.height + 20)
        }
        
        label.bounds = CGRect(origin: CGPoint.zero, size: size)
        label.center = CGPoint(x: label.bounds.midX + 20, y: label.bounds.midY + 10)
        
        return v
    }()
}

extension CafeViewController {
    func dail(_ phoneNumber: String) {
        UIApplication.shared.openURL(URL(string: "tel:" + phoneNumber)!)
    }
    
    func alertDail(_ phoneNumbers: [String]) {
        let actions = phoneNumbers.map{UIAlertAction(title: $0, style:.default) { [unowned self] action in
                self.dail(action.title!)
            }
        }
        
        let alertController = UIAlertController(title: "拨打电话", message: "", preferredStyle: actions.count > 1 ? .actionSheet : .alert)
        
        actions.forEach {
            alertController.addAction($0)
        }
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}
