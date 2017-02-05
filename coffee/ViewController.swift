//
//  ViewController.swift
//  coffee
//
//  Created by flexih on 11/27/15.
//  Copyright © 2015 flexih. All rights reserved.
//

import UIKit
import MapKit
import Static
import SafariServices

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.rowHeight = 85
        view.backgroundColor = UIColor.clear
        return view
    }()

    var didUpdateUserLocation = false
    var userCityName = ""
    
    let dataSource = DataSource()
    lazy var cityList = CityList.defaultList()
    lazy var menuListViewController: MenuListViewController = {
        let vc = MenuListViewController(cityList: self.cityList)
        vc.selectedCity = { [unowned self] cityName in
            self.mapView.showsUserLocation = self.cityList.sameCity(self.userCityName, other: cityName)
            self.locateCityName(cityName)
            self.hideMenuList()
        }
        return vc
    }()
    
    lazy var listButton: HamburgerButton = {
        let button = HamburgerButton(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        button.addTarget(self, action: #selector(toggleList(_ :)), for: .touchUpInside)
        button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("商店", for: UIControlState())
        button.titleLabel?.textColor = UIColor(red: 0.24, green: 0.26, blue: 0.29, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.bounds = CGRect(x: 0, y: 0, width: 45, height: 0)
        button.addTarget(self, action: #selector(presentShop), for: .touchUpInside)
        return button
    }()
    
    lazy var animation: CABasicAnimation = {
        let a = CABasicAnimation(keyPath: "path")
        a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        a.duration = 0.5
        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        let titleView = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: listButton)

        if let _ = (UIApplication.shared.delegate as! AppDelegate).shopURI {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        }
        
        let lineView = UIView()
        
        lineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        visualEffectView.addSubview(lineView)
        
        lineView.snp.makeConstraints { make in
            let height = 1 / UIScreen.main.scale
            make.leading.trailing.equalTo(0)
            make.height.equalTo(height)
            make.bottom.equalTo(visualEffectView.snp.top)
        }
        
        visualEffectView.contentView.addSubview(tableView)

        let displayRowCount = UIScreen.main.bounds.height >= 667 ? 4 : 3
        let tableViewHeight: CGFloat = tableView.rowHeight * CGFloat(displayRowCount)

        visualEffectView.snp.remakeConstraints { make in 
            make.top.equalTo(mapView.snp.bottom).offset(-tableViewHeight)
        }

        tableView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(visualEffectView)
            make.top.bottom.equalTo(visualEffectView)
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.cafe_edgeInsets = UIEdgeInsets(top: 64, left: 0, bottom: tableViewHeight, right: 0)

        loadCafesData()
        fetchCafeData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideMenuList() {
        listButton.showsMenu = !listButton.showsMenu
        
        UIView.animate(withDuration: 0.25, animations: {
            self.menuListViewController.view.alpha = 0
            }, completion: { finished in
                self.menuListViewController.view.removeFromSuperview()
                self.menuListViewController.removeFromParentViewController()
        }) 
    }

    func toggleList(_ sender: HamburgerButton) {
        func circleRect(radius: CGFloat) -> CGRect {
            return CGRect(x: -radius, y: -radius, width: radius * 2, height:radius * 2)
        }
        
        tableView.scrollsToTop = sender.showsMenu
        
        if sender.showsMenu {
            hideMenuList()
            if let _ = (UIApplication.shared.delegate as! AppDelegate).shopURI {
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            }
            return
        }
        
        sender.showsMenu = !sender.showsMenu
        
        view.addSubview(menuListViewController.view)
        addChildViewController(menuListViewController)
        
        menuListViewController.view.alpha = 1
        menuListViewController.view.frame = UIEdgeInsetsInsetRect(view.bounds, UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        
        let size = UIScreen.main.bounds.size
        let diagonal = ceil(sqrt(size.width * size.width + size.height * size.height))
        let startPath = UIBezierPath(ovalIn: circleRect(radius: 0))
        let endPath = UIBezierPath(ovalIn: circleRect(radius: diagonal))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.delegate = AnimationDelegate { [weak self] in
            if let strongSelf = self {
                strongSelf.menuListViewController.view.layer.mask = nil
                strongSelf.animation.delegate = nil
            }
        }

        menuListViewController.view.layer.mask = maskLayer
        maskLayer.frame = menuListViewController.view.bounds
        maskLayer.add(animation, forKey: "reveal")
    }

    func presentShop() {
        let shopURL = (UIApplication.shared.delegate as! AppDelegate).shopURI.map{URL(string: $0)!}

        if let shopURL = shopURL {
            if #available(iOS 9.0, *) {
                present(SFSafariViewController(url: shopURL), animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(shopURL)
            }
        }
    }
    
    func presentSetting() {
        let vc = UIViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

