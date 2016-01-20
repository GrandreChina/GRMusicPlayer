//
//  ViewController.swift
//  DBDT
//
//  Created by Grandre on 15/12/31.
//  Copyright © 2015年 革码者. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer
import AVFoundation

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,HTTPProtocol{
    
    @IBOutlet weak var rotationt头像y约束: NSLayoutConstraint!
    @IBOutlet weak var progressBg2: UIImageView!
    @IBOutlet weak var timePlayer: UILabel!
    @IBOutlet weak var progressBg: UIImageView!
    @IBOutlet weak var geQuLieBiao: UITableView!
    @IBOutlet weak var blackGroundImageView: BlueEffectImageViewClass!
    @IBOutlet weak var RorationImage: xuanzhuanfengmian!
    
    @IBOutlet weak var StackView_Button: UIStackView!

    @IBOutlet weak var preBtn: UIButton!
 
    @IBOutlet weak var pauseBtnn: pauseBtn!
    @IBOutlet weak var btnOrderGet: orderBtn!
    @IBOutlet weak var nextBtnn: UIButton!
    @IBOutlet weak var listBtnn: UIButton!
    @IBAction func btnOrder(sender: orderBtn) {
        objectAnimate(sender)
        switch sender.order{
        
        case  1:
                self.clearAllNotice()
                self.noticeOnlyTextAutoClearGR("列表循环")
        case  2:
                self.clearAllNotice()
                self.noticeOnlyTextAutoClearGR("随机播放")
        case  3:
                self.clearAllNotice()
                self.noticeOnlyTextAutoClearGR("单曲循环")
        default:print("4444")
        }
        
    }
    @IBAction func btnPre(sender: UIButton) {
        objectAnimate(sender)
        ifAutoFinish = false
        if (cellIndex - 1) >= 0{
            musicPlayerGR(cellIndex - 1)
            cellIndex--
        }else{
            self.clearAllNotice()
            self.noticeOnlyTextAutoClearGR("已经是第一首了")
        }
        
        
    }
    @IBAction func btnNext(sender: UIButton) {
        objectAnimate(sender)
        ifAutoFinish = false
        if (cellIndex + 1) < gequData.count{
            musicPlayerGR(cellIndex + 1)
            cellIndex++
        }else{
            self.clearAllNotice()
            self.noticeOnlyTextAutoClearGR("已经是最后一首了")
        }
        
    }
    @IBAction func btnPause(sender: pauseBtn) {
        objectAnimate(sender)
        if sender.isPlay{
            audioPlayer.play()
        }else{
            audioPlayer.pause()
        }
        
    }
//*****************************************
//按钮的动画
//
//
//*****************************************
    func objectAnimate(object:AnyObject){
        
            let keyAnimate = CAKeyframeAnimation(keyPath: "transform.rotation")
        
            keyAnimate.values = [ -0.3, 0.3, -0.3,0.3,0]
     
        
            let scaleAnimate = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleAnimate.values = [1.1,1.2,1.1,1]
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [keyAnimate, scaleAnimate]
        groupAnimation.removedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        
        groupAnimation.duration = 0.5
        
        groupAnimation.delegate = self
        groupAnimation.repeatCount = 1
        
        
        
        object.layer.addAnimation(groupAnimation, forKey: "aaa")
        
    }
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        animate屏保()
//    }
    func animate屏保(){
       
        let path = UIBezierPath()
        let point = UIScreen.mainScreen().bounds.size
        path.moveToPoint(CGPointMake(point.width/2, point.height))
        
        //这是二次贝塞尔曲线的接口，利用此接口，可以定义一条贝塞尔曲线轨迹
        path.addCurveToPoint(CGPointMake(point.width/2, point.height - 300), controlPoint1: CGPointMake(point.width/2 - 50, point.height - 75), controlPoint2: CGPointMake(point.width/2 + 50 , point.height - 225))
        //        path.addQuadCurveToPoint(CGPointMake(400, 150), controlPoint: CGPointMake(225, 300))
        
        
        let plane = UIImageView(frame: CGRectMake(0, 0, 85, 60))
        //这里可以放一张飞机图片
        plane.image = UIImage(named: "logo")
        plane.center = CGPointMake(0, 150)
        plane.layer.anchorPoint = CGPointMake(0.5, 0.5)
        self.view.addSubview(plane)
        
        let animate = CAKeyframeAnimation(keyPath: "position")
        animate.duration = 4
        animate.path = path.CGPath
        animate.fillMode = kCAFillModeForwards
        animate.removedOnCompletion = false
        animate.delegate = self
        
        //设置此属性，可以使得飞机在飞行时自动调整角度
        animate.rotationMode = kCAAnimationRotateAuto
        
        //        animate.setValue(plane.layer, forKey: "plane.layer")
        plane.layer.addAnimation(animate, forKey: "animateTestThree")
    }
    
    let http = HTTPController()
    var channelData:[JSON] = []
    var gequData:[JSON] = []
    
    var channelID:String! =  "     channelID:  " + "4"
    
    var imageCache = [String:UIImage]()
    
//    let audioPlayer = MPMoviePlayerController()
    var audioPlayer :AVPlayer!
    var playItem:AVPlayerItem!
    
    var timer:NSTimer?
    
    var cellIndex:Int = 0
//*****************************************
//接受到url后音乐播放
//
//
//*****************************************
    func musicPlayerGR(index: Int){
        let url =  gequData[index]["url"].string!

//        audioPlayer.stop()
//        audioPlayer.contentURL = NSURL(string: url)
//        audioPlayer.play()
//        
        playItem =  AVPlayerItem(URL: NSURL(string: url)!)
        audioPlayer = AVPlayer(playerItem: playItem)
        audioPlayer.play()
        
        timer?.invalidate()
        timePlayer.text = "00:00"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "update", userInfo: nil, repeats: true)
        ifAutoFinish = true
        
        let pictureUrl = gequData[index]["picture"].string!
        getImageFromCache(pictureUrl, imageView: self.RorationImage)
        getImageFromCache(pictureUrl, imageView: self.blackGroundImageView)
    }

    
    func update(){
//        let c = audioPlayer.currentPlaybackTime
        let c = audioPlayer.currentTime().seconds
        var time = ""
        if c > 0.0{  // c>0.0 必须判断
//            let t = audioPlayer.duration
            let t = audioPlayer.currentItem!.duration.seconds
            //计算百分比
            let pro:CGFloat = CGFloat(c/t)
            progressBg.layer.frame.size.width = view.frame.size.width * pro
//            progressBg.frame.size = CGSize(width:view.frame.size.width * pro , height: 40)
          
            let intC = Int(c)
            let s = intC % 60
            let m = intC / 60
            if m < 10{
                time = "0\(m):"
            }else{
                time = "\(m):"
            }
            
            if s < 10{
                time += "0\(s)"
            }else{
                time += "\(s)"
            }
            
            timePlayer.text = time
        }
//        self.objectAnimate(self.RorationImage)
    }
//   回调方法
    func getChannelIdFromPinDaoLieBiao(channel:String)->Void{
        self.channelID = "     channelID:  " + channel
        http.onSearch("http://douban.fm/j/mine/playlist?type=n&channel=" + channel + "&from=mainsite")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "channelliebiao"{
                let destV = segue.destinationViewController as! PinDaoViewController
                destV.sendChannelIdtoViewController = self.getChannelIdFromPinDaoLieBiao
                destV.channelData = self.channelData
                destV.getBackgroundView = self.blackGroundImageView.image
            }
    }
//    委托协议方法
    func didReceiveResults(result:AnyObject) {
        let jsonResult = JSON(result)
//        转化成数组再进行判断
        if let data = jsonResult["channels"].array{
            self.channelData = data
//            print(self.channelData)
            
        }else if let song = jsonResult["song"].array{
            ifAutoFinish = false
            self.gequData = song
            geQuLieBiao.reloadData()
            firstLoadMusic()
        }
    }
//*****************************************
//界面首次载入初始化 viewDidLoad()
//
//
//*****************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "🐷界面"
      
        http.delegate = self
        http.onSearch("http://www.douban.com/j/app/radio/channels")
        http.onSearch("http://douban.fm/j/mine/playlist?type=n&channel=4&from=mainsite")
        
        geQuLieBiao.backgroundColor = UIColor.clearColor()
       
//        播放结束通知
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinishPlayer", name: MPMoviePlayerPlaybackDidFinishNotification, object: audioPlayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinishPlayer", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playItem)
        
    }
//*****************************************
//音乐播放器是否自动播放完成
//
//
//*****************************************
    var ifAutoFinish:Bool = true
    func didFinishPlayer(){
        print("hello grandre")
        if ifAutoFinish{
            switch btnOrderGet.order{
            case   1:
                if (cellIndex + 1) < gequData.count{
                    musicPlayerGR(cellIndex + 1)
                    cellIndex++
                }else{
                    cellIndex = 0
                    musicPlayerGR(cellIndex)
                }
            case   2:
                cellIndex = random() % gequData.count
                musicPlayerGR(cellIndex)
            case   3:
                musicPlayerGR(cellIndex)
            default :"hello"
            }
        }else{
            ifAutoFinish = true
        }
    }
//*****************************************
// 图片缓存策略
//
//
//*****************************************
    func getImageFromCache(url:String,imageView:UIImageView){
        if let image = imageCache["url"]{
            imageView.image = image
        }else{
            Alamofire.request(.GET, url).response(completionHandler: { (_, _, d, e) -> Void in
                let image = UIImage(data: d!)
                self.imageCache[url] = image
                imageView.image = image
            })
        }
    }
//*****************************************
//首次载入音乐和背景图片，旋转图片
//
//
//*****************************************
    func firstLoadMusic(){
        musicPlayerGR(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
//*****************************************
// viewWillAppear
// 界面动画初始化
//
//*****************************************
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    
        RorationImage.stAnimation()
        
        
//      UIView动画的前奏设置
        self.RorationImage.transform = CGAffineTransformMakeScale(2, 2)
        self.RorationImage.layer.position.y = -210
//        self.StackView_Button.layer.position.y = -228
        self.StackView_Button.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 15, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.RorationImage.transform = CGAffineTransformMakeScale(1, 1)
            self.RorationImage.layer.position.y = 10 + 200
//            self.StackView_Button.layer.position.y = 228
            self.StackView_Button.transform = CGAffineTransformMakeScale(1, 1)
            }) { (finish) -> Void in
                self.RorationImage.transform = CGAffineTransformIdentity
                print(finish)
        }
        
        let caTransition = CATransition()
        caTransition.type = "cube"
        caTransition.subtype = kCAAnimationCubicPaced
        
        caTransition.duration = 1
        caTransition.repeatCount = 1
        
        caTransition.setValue("one", forKeyPath: "whichAnimation")
        
        self.geQuLieBiao.layer.addAnimation(caTransition, forKey: "111")

        
  
       
    }
//*****************************************
// 歌曲列表的定义
//    
//    
//*****************************************
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gequData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("gequliebiao", forIndexPath: indexPath)
        
        let cellData = gequData[indexPath.row]
        cell.textLabel?.text = cellData["title"].string
        cell.detailTextLabel?.text = cellData["artist"].string! + self.channelID
//        cell的image跟圆角要先设定一下，让其后面再被覆盖。不然获取到image之后再设的话，table里显示不了。
        cell.imageView?.image = UIImage(named: "thumb")
        cell.imageView?.layer.cornerRadius = 22
        cell.imageView?.layer.masksToBounds = true
        
        if let pictureUrl = cellData["picture"].string{
            getImageFromCache(pictureUrl, imageView: cell.imageView!)
            
        }
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ifAutoFinish = false
        cellIndex = indexPath.row
        musicPlayerGR(indexPath.row)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.5) { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
   
    
}

