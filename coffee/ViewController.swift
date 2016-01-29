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
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: .Plain)
        view.rowHeight = 85
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    lazy var bannerView: GADBannerView = {
        let v = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        v.delegate = self
        v.adUnitID = "ca-app-pub-4396150446847703/1899901748"
        v.rootViewController = self
        return v
    }()

    var didUpdateUserLocation = false
    
    let dataSource = DataSource()
    lazy var cityList = CityList()
    lazy var menuListViewController: MenuListViewController = {
        let vc = MenuListViewController(cityList: self.cityList)
        vc.selectedCity = { [unowned self] cityName in
            self.locateCityName(cityName)
            self.hideMenuList()
        }
        return vc
    }()
    
    lazy var listButton: HamburgerButton = {
        let button = HamburgerButton(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        button.addTarget(self, action: "toggleList:", forControlEvents: .TouchUpInside)
        button.transform = CGAffineTransformMakeScale(0.5, 0.5)
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

        if let _ = (UIApplication.sharedApplication().delegate as! AppDelegate).shopURI {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "商店", style: .Plain, target: self, action: "presentShop")
        }
        
        let lineView = UIView()
        
        lineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        visualEffectView.addSubview(lineView)
        
        lineView.snp_makeConstraints { make in
            let height = 1 / UIScreen.mainScreen().scale
            make.leading.trailing.equalTo(0)
            make.height.equalTo(height)
            make.bottom.equalTo(visualEffectView.snp_top)
        }
        
        visualEffectView.contentView.addSubview(tableView)

        let displayRowCount = CGRectGetHeight(UIScreen.mainScreen().bounds) >= 667 ? 4 : 3
        let tableViewHeight: CGFloat = tableView.rowHeight * CGFloat(displayRowCount)

        visualEffectView.snp_remakeConstraints { make in 
            make.top.equalTo(mapView.snp_bottom).offset(-tableViewHeight)
        }

        tableView.snp_remakeConstraints { make in
            make.leading.trailing.equalTo(visualEffectView)
            make.top.bottom.equalTo(visualEffectView)
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.cafe_edgeInsets = UIEdgeInsets(top: 64, left: 0, bottom: tableViewHeight, right: 0)

        loadCafesData()
        fetchCafeData()
        
        loadAD()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideMenuList() {
        listButton.showsMenu = !listButton.showsMenu
        
        UIView.animateWithDuration(0.25, animations: {
            self.menuListViewController.view.alpha = 0
            }) { finished in
                self.menuListViewController.view.removeFromSuperview()
                self.menuListViewController.removeFromParentViewController()
        }
    }

    func toggleList(sender: HamburgerButton) {
        func circleRect(radius radius: CGFloat) -> CGRect {
            return CGRect(x: -radius, y: -radius, width: radius * 2, height:radius * 2)
        }
        
        tableView.scrollsToTop = sender.showsMenu
        
        if sender.showsMenu {
            hideMenuList()
            return
        }
        
        sender.showsMenu = !sender.showsMenu
        
        view.addSubview(menuListViewController.view)
        addChildViewController(menuListViewController)
        
        menuListViewController.view.alpha = 1
        menuListViewController.view.frame = UIEdgeInsetsInsetRect(view.bounds, UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        
        let size = UIScreen.mainScreen().bounds.size
        let diagonal = ceil(sqrt(size.width * size.width + size.height * size.height))
        let startPath = UIBezierPath(ovalInRect: circleRect(radius: 0))
        let endPath = UIBezierPath(ovalInRect: circleRect(radius: diagonal))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.CGPath
        
        animation.fromValue = startPath.CGPath
        animation.toValue = endPath.CGPath
        animation.delegate = AnimationDelegate { [weak self] in
            if let strongSelf = self {
                strongSelf.menuListViewController.view.layer.mask = nil
                strongSelf.animation.delegate = nil
            }
        }

        menuListViewController.view.layer.mask = maskLayer
        maskLayer.frame = menuListViewController.view.bounds
        maskLayer.addAnimation(animation, forKey: "reveal")
    }

    func presentShop() {
        let shopURL = (UIApplication.sharedApplication().delegate as! AppDelegate).shopURI.map{NSURL(string: $0)!}

        if let shopURL = shopURL {
            if #available(iOS 9.0, *) {
                presentViewController(SFSafariViewController(URL: shopURL), animated: true, completion: nil)
            } else {
                UIApplication.sharedApplication().openURL(shopURL)
            }
        }
    }
    
}

extension ViewController: GADBannerViewDelegate {
    
    func loadAD() {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).showAD {
            let ADRequest = GADRequest()
            #if arch(x86_64)
            ADRequest.testDevices = [kGADSimulatorID];
            #endif
            bannerView.loadRequest(ADRequest)
        }
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        view.addSubview(bannerView)
        bannerView.snp_makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}


