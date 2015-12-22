//
//  ViewController.swift
//  Stock Decisions
//
//  Created by Andrew Lee on 9/2/15.
//  Copyright (c) 2015 Andrew Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    
    private var stocks: [(String,Double,Double)] = [("AAPL",+5.0,+100),("FB",+5.0,+100),("GOOG",-5.0,+100),("TSLA",+5.0,+100)]
    var newInput: String = ""
    var placeholderNum: Double = 5.0
    var placeholderPrice: Double = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stocksUpdated:", name: kNotificationStocksUpdated, object: nil)
        self.updateStocks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //2
    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
    return stocks.count
    }
    
    //3
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "stockCell")
    //cell.textLabel!.text = stocks[indexPath.row]
    cell.textLabel!.text = "\(stocks[indexPath.row].0)" + " " + "$" + "\(stocks[indexPath.row].2)"  //position 0 of the tuple: The Symbol "AAPL"
    cell.detailTextLabel!.text = "\(stocks[indexPath.row].1)" + "%" //position 1 of the tuple: The value "99" into String
    return cell
    }
    
    //4
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stockSingleton:singletonController = singletonController.sharedInstance
        stockSingleton.printTest()
    }
    
    //Customize the cell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //1
        cell.backgroundColor = UIColor.blackColor()

        switch stocks[indexPath.row].1 {
        case let x where x < 0.0:
            cell.detailTextLabel!.backgroundColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        case let x where x > 0.0:
            cell.detailTextLabel!.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        case let x:
            cell.detailTextLabel!.backgroundColor = UIColor(red: 44.0/255.0, green: 186.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        }
        
        //2
        //cell.backgroundColor = UIColor.blackColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
        //cell.textLabel!.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 48)
        //cell.detailTextLabel!.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 48)
        cell.textLabel!.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        cell.textLabel!.shadowOffset = CGSize(width: 0, height: 1)
        cell.detailTextLabel!.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        cell.detailTextLabel!.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func updateStocks() {
        let stockManager:singletonController = singletonController.sharedInstance
        stockManager.updateListOfSymbols(stocks)
        
        //Repeat this method after 15 secs. (For simplicity of the tutorial we are not cancelling it never)
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(15 * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            {
                self.updateStocks()
            }
        )
    
    }
    //4
    func stocksUpdated(notification: NSNotification) {
        let values = (notification.userInfo as! Dictionary<String,NSArray>)
        let stocksReceived:NSArray = values[kNotificationStocksUpdated]!
        stocks.removeAll(keepCapacity: false)
        for quote in stocksReceived {
            let quoteDict:NSDictionary = quote as! NSDictionary
            let changeInPercentString = quoteDict["ChangeinPercent"] as! String
            let changeInPercentStringClean: NSString = (changeInPercentString as NSString).substringToIndex(changeInPercentString.characters.count-1)
            let LastTradePriceOnlyString = quoteDict["LastTradePriceOnly"] as! String
            let LastTradePriceOnlyStringClean: NSString = (LastTradePriceOnlyString as NSString).substringToIndex(LastTradePriceOnlyString.characters.count)
            stocks.append(quoteDict["symbol"] as! String,changeInPercentStringClean.doubleValue,LastTradePriceOnlyStringClean.doubleValue)
        }
        table.reloadData()
        NSLog("Symbols Values updated :)")
        

    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    // placeholderPrice as Double,
    
    // After the user adds a new element, it is appended to the array and the UITableView is reloaded
    // From newCell //
    @IBAction func done(segue:UIStoryboardSegue) {
        let DetailVC = segue.sourceViewController as! newTicker
        newInput = DetailVC.choice
        NSLog("%@ was received at least", newInput)
        // Checks to see if the string is empty
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if newInput.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
            stocks.append(newInput as String, placeholderNum as Double, placeholderPrice as Double)
            NSLog("Something was entered")
        }
        else {
            NSLog("Nothing was entered")
        }
        for var y=0; y != stocks.count; y++ {
            
            print(stocks[y])
        }
        
        NSLog("newInput = %@", newInput)
        
        NSLog("inputArray.count in done action = %d", stocks.count)
        
        self.updateStocks()
        
        //self.table.reloadData()
        
    }
    
    
    
    
    
    
}
