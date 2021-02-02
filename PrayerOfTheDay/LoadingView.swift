//
//  LoadingView.swift
//  AidTree-iOS
//
//  Created by Travis Wade on 3/3/15.
//  Copyright (c) 2015 Travis Wade. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var spinnerView: UIActivityIndicatorView!

    var view: LoadingView?
    var spinner: UIActivityViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let viewTemp = self.loadNib()
        viewTemp.frame = self.bounds
        viewTemp.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.view = viewTemp
        
        self.view?.spinnerView.startAnimating()
        
        self.addSubview(self.view!)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func awakeAfter(using coder: NSCoder) -> Any? {
        if self.subviews.count == 0 {
            let viewTemp = self.loadNib()
            viewTemp.translatesAutoresizingMaskIntoConstraints = false
            let contraints = self.constraints
            self.removeConstraints(contraints)
            viewTemp.addConstraints(contraints)
            self.view = viewTemp
            
            return self.view
        }
        return self
    }
    
    private func loadNib() -> LoadingView {
        let bundle = Bundle(for: type(of: self))
        let view = bundle.loadNibNamed("LoadingView", owner: nil, options: nil)![0] as! LoadingView
        return view
    }

    func setLoadingLabel(message: String) {
        self.view?.label.text = message
    }

}
