//
//  PinDaoViewController.swift
//  DBDT
//
//  Created by Grandre on 16/1/6.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PinDaoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: BlueEffectImageViewClass!
    
    var channelData:[JSON] = []
    var sendChannelIdtoViewController:((String)->Void)!
    var getBackgroundView:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.frame = self.view.frame
//        self.navigationController?.hidesBarsOnTap = true
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
//        backgroundColor 是最底下的color
//        self.navigationController?.navigationBar.backgroundColor = UIColor.redColor()
        
//        barTintColor在backgroundColor上面，所以看到的是barTintColor
        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
//        tintColor是BackItem的Color
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blueColor(),NSFontAttributeName:UIFont(name: "Chalkduster", size: 20)!]


        
//        完全隐藏backItem
//       self.navigationItem.setHidesBackButton(true, animated: true)
        
//重新定义backItem，将覆盖原来的BackItem.与storyboard中拖入一个item，效果一样。都是覆盖原来的backitem。
//        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "function"), animated: true)
        
//  self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "function")
//    设置backItem只有“<”，
    self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "<Grandre", style: UIBarButtonItemStyle.Plain, target: self, action: "function"), animated: true)
    self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blueColor(),NSFontAttributeName: UIFont(name: "Chalkduster", size: 13)!], forState: UIControlState.Normal)
//        self.navigationItem.leftBarButtonItem?.setTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: UIBarMetrics.Default)
//将导航栏设置成透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage =  UIImage()
        self.navigationController?.navigationBar.translucent = true
//        
        self.navigationItem.title = "channel list"
        
        
        self.tableView.backgroundColor = UIColor.blackColor()
        self.tableView.layer.opacity = 0.5
//        self.tableView.layer.opaque设置成true，即不透明时，如果设置了self.tableView.layer.opacity = 0.5，也还是有透明的的效果
//        self.tableView.layer.opaque = true
        
        
        self.backgroundView.image = self.getBackgroundView
    }
  
    func function(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pcell", forIndexPath: indexPath)
        
        let cellContent = channelData[indexPath.row]
        cell.textLabel?.text = cellContent["name"].string
        cell.textLabel?.textColor = UIColor.greenColor()
        let detailContent = cellContent["channel_id"].stringValue
        
        cell.detailTextLabel?.text = "\(detailContent)"
        cell.detailTextLabel?.textColor = UIColor.redColor()
        cell.detailTextLabel?.font = UIFont(name: "Chalkduster", size: 20)
        //        print(cell.subviews.first?.subviews.count)
        //        print(cell.contentView.subviews.count)
        //        print((cell.viewWithTag(1) as! UITextField).placeholder)
       
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectChannelID = channelData[indexPath.row]["channel_id"]
        let id = "\(selectChannelID)"
        self.sendChannelIdtoViewController(id)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.5) { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        
        }
        
    }
   
    
}
