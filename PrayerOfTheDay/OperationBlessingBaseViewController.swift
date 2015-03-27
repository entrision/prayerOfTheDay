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

        var headerContainer = UIView(frame: CGRectMake(20, 40, 320, 40))
        var imageView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        imageView.image = UIImage(named:"prayer-hands.png")
        headerContainer.addSubview(imageView)
        
        var topLabel = UILabel(frame: CGRectMake(48, 0, 100, 15))
        topLabel.text = "DAILY PHOTO"
        topLabel.textColor = UIColor.whiteColor()
        topLabel.font = UIFont(name: "Raleway-Bold", size: 14)
        headerContainer.addSubview(topLabel)
        
        var bottomLabel = UILabel(frame: CGRectMake(48, 15, 100, 20))
        bottomLabel.text = "PRAYER"
        bottomLabel.textColor = UIColor.whiteColor()
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
