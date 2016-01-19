//
//  pindaoliebiao.swift
//  DBDT
//
//  Created by Grandre on 16/1/1.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class pindaoliebiao: UITableViewController {

   
    var channelData:[JSON] = []
    var sendChannelIdtoViewController:((String)->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.clearColor()
        
//        
//        let tempTable = self.tableView
//        let tempTableFrame = self.tableView.layer.frame
//        let backgroundView = UIImageView()
//        backgroundView.frame = tempTableFrame
//        backgroundView.image = UIImage(named: "logo")
//        
//        let uiview = UIView()
//        uiview.frame = tempTableFrame
//        self.view = uiview
//        
//        
//        
//        self.view.addSubview(backgroundView)
//        self.view.addSubview(tempTable)
//        self.view.bringSubviewToFront(tempTable)
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
      
        self.navigationItem.title = "频道列表"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "🚙主界面", style: UIBarButtonItemStyle.Plain, target: self, action: "PopToLast")
    }

//    func PopToLast(){
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pcell", forIndexPath: indexPath)
        
        let cellContent = channelData[indexPath.row]
        cell.textLabel?.text = cellContent["name"].string
        let detailContent = cellContent["channel_id"].stringValue
        cell.detailTextLabel?.text = "\(detailContent)"
//        print(cell.subviews.first?.subviews.count)
//        print(cell.contentView.subviews.count)
//        print((cell.viewWithTag(1) as! UITextField).placeholder)
//        let c = cell.contentView.subviews[0] as! UILabel
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectChannelID = channelData[indexPath.row]["channel_id"]
       let id = "\(selectChannelID)"
        self.sendChannelIdtoViewController(id)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.5) { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
    
}
