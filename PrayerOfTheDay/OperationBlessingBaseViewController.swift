//
//  OperationBlessingBaseViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 3/26/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit

class OperationBlessingBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerContainer = UIView(frame: CGRect(x: 20, y: 40, width: 320, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = UIImage(named:"prayer-hands.png")
        headerContainer.addSubview(imageView)
        
        let topLabel = UILabel(frame: CGRect(x: 48, y: 0, width: 100, height: 15))
        topLabel.text = "DAILY PHOTO"
        topLabel.textColor = UIColor.white
        topLabel.font = UIFont(name: "Raleway-Bold", size: 14)
        headerContainer.addSubview(topLabel)
        
        let bottomLabel = UILabel(frame: CGRect(x: 48, y: 15, width: 100, height: 20))
        bottomLabel.text = "PRAYER"
        bottomLabel.textColor = UIColor.white
        bottomLabel.font = UIFont(name: "Raleway", size: 23)
        headerContainer.addSubview(bottomLabel)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = ""
        self.navigationItem.titleView = headerContainer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
