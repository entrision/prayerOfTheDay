
//
//  WebService.swift
//  AidTree-iOS
//
//  Created by Travis Wade on 12/30/14.
//  Copyright (c) 2014 Travis Wade. All rights reserved.
//

import UIKit

class WebService: NSObject, NSURLConnectionDelegate {
    var baseAddress:NSString!
    
    override init() {
        super.init()
        let path = NSBundle.mainBundle().pathForResource("settings", ofType: "plist")
        let settings:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!) as NSMutableDictionary!
        baseAddress = settings.objectForKey("baseAddress") as! NSString
    }
    
    // MARK: - base methods
    // --------------------------------------------------
    
    func get(webURL: NSString, success: (response: NSURLResponse, data: NSData)->(), failure: (error:NSError)->()) {
        print("in webservice get")
        let url:NSURL = NSURL(string: NSString(format: "@@", baseAddress, webURL) as String)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
            completionHandler: { (connResponse: NSURLResponse?, connData: NSData?, connError: NSError?) -> Void in
            
                if let data = connData {
                    
                    success(response: connResponse!, data: data)
                    
                } else {
                    failure(error: connError!)
                }
                
                
        })

    }
    
    
    
/*
    func post(webURL: NSString, arguements: NSString, success: (response: NSURLResponse, data: NSData)->(), failure: (error:NSError)->()) {
        var url:NSURL = NSURL(string: baseAddress + webURL)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let args:String? = arguements
        
        if (args != nil) {
            let data = arguements.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = data
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
            completionHandler: { (connResponse: NSURLResponse!, connData: NSData!, connError: NSError!) -> Void in
                if (connError == nil) {
                    success(response: connResponse, data: connData)
                } else {
                    failure(error: connError)
                }
        })
        
    }
    
    func post(webURL: NSString, arguements: NSString, apiToken:NSString, success: (response: NSURLResponse, data: NSData)->(), failure: (error:NSError)->()) {
        var url:NSURL = NSURL(string: baseAddress + webURL)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        
        let args:String? = arguements
        
        if (args != nil) {
            let data = arguements.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = data
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
            completionHandler: { (connResponse: NSURLResponse!, connData: NSData!, connError: NSError!) -> Void in
                if (connError == nil) {
                    success(response: connResponse, data: connData)
                } else {
                    failure(error: connError)
                }
        })
        
    }
    
    func put(webURL: NSString, apiToken:NSString, success:(response:NSURLResponse, data: NSData)->(), failure: (error: NSError)->()) {
        var url:NSURL = NSURL(string: baseAddress + webURL)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
            completionHandler: { (connResponse: NSURLResponse!, connData: NSData!, connError: NSError!) -> Void in
                if (connError == nil) {
                    success(response: connResponse, data: connData)
                } else {
                    failure(error: connError)
                }
        })

    }
    
    func patch(webURL: NSString, apiToken:NSString, success:(response:NSURLResponse, data: NSData)->(), failure: (error: NSError)->()) {
        var url:NSURL = NSURL(string: baseAddress + webURL)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PATCH"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
            completionHandler: { (connResponse: NSURLResponse!, connData: NSData!, connError: NSError!) -> Void in
                if (connError == nil) {
                    success(response: connResponse, data: connData)
                } else {
                    failure(error: connError)
                }
        })
    }
*/
}
