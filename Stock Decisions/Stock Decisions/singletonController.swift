//
//  singletonController.swift
//  Stock Decisions
//
//  Created by Andrew Lee on 9/2/15.
//  Copyright (c) 2015 Andrew Lee. All rights reserved.
//

import UIKit
import Foundation
let kNotificationStocksUpdated = "stocksUpdated"

class singletonController: UIViewController {

    class var sharedInstance : singletonController {
        struct Static {
            static let instance : singletonController = singletonController()
        }
        return Static.instance
    }
    
    func printTest() {
        NSLog("TEST OK :)")
    }
    
    
    func updateListOfSymbols(stocks:Array<(String,Double,Double)>) ->() {
        
        //1: YAHOO Finance API: Request for a list of symbols example:
        //http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN ("AAPL","GOOG","FB")&format=json&env=http://datatables.org/alltables.env
        
        //2: Build the URL as above with our array of symbols
        var stringQuotes = "(";
        for quoteTuple in stocks {
            stringQuotes = stringQuotes+"\""+quoteTuple.0+"\","
        }
        stringQuotes = stringQuotes.substringToIndex(stringQuotes.endIndex.predecessor())
        stringQuotes = stringQuotes + ")"
        
        let urlString:String = ("http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN "+stringQuotes+"&format=json&env=http://datatables.org/alltables.env").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url : NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL:url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        //3: Completion block/Clousure for the NSURLSessionDataTask
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                var err: NSError?
                //4: JSON process
                let jsonDict = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                if(err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
                else {
                    //5: Extract the Quotesand Values and send them inside a NSNotification
                    let quotes:NSArray = ((jsonDict.objectForKey("query") as! NSDictionary).objectForKey("results") as! NSDictionary).objectForKey("quote") as! NSArray
                    dispatch_async(dispatch_get_main_queue(), {
                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationStocksUpdated, object: nil, userInfo: [kNotificationStocksUpdated:quotes])
                    })
                    print(quotes)
                }
            }
        })
        
        //6: DONT FORGET to LAUNCH the NSURLSessionDataTask!!!!!!
        task.resume()
        
    }
    
    
    
    
}
