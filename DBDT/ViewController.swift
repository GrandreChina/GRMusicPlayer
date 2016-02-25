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
import CircleSlider

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,HTTPProtocol{
    
    var ifFirstLogin = true
    var animation音乐波动:GRMusicAnimation!
    
    @IBOutlet weak var currentPlayer背景: UIView!
    @IBOutlet weak var currentPlayerImage: UIImageView!
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var currentPlayerBtn: CurrentPlayerBtn!
    
    var slider: CircleSlider!
    @IBOutlet weak var slider圆形容器: UIView!
    
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
            self.animation音乐波动.GRAnimateStart()
        }else{
            audioPlayer.pause()
            self.animation音乐波动.GRAnimateStop()
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
//*****************************************
//crcilSlider的动画
//
//
//*****************************************
    var options = [
//        CircleSliderOption.BarColor(UIColor(red: 198/255, green: 244/255, blue: 23/255, alpha: 0.2)),
        CircleSliderOption.BarColor(UIColor.clearColor()),
        .ThumbColor(UIColor(red: 196/255, green: 82/255, blue: 181/255, alpha: 1)),
        .TrackingColor(UIColor(red: 59/255, green: 255/255, blue: 60/255, alpha: 1)),
        .BarWidth(4),
        .StartAngle(-90),
        .MaxValue(100),
        .MinValue(0)
    ]
    func slider圆形初始化(){
        
        print("slider已经初始化")
        
        slider = CircleSlider(frame: self.slider圆形容器.bounds, options: options)
        slider.addTarget(self, action: "sliderValueChange", forControlEvents: UIControlEvents.ValueChanged)
        slider.enabled = false
        
        self.slider圆形容器.addSubview(slider)
        self.slider圆形容器.backgroundColor = UIColor.clearColor()
        
        
    }
    func sliderValueChange(){
//        print(slider.value)
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
    var cellIndexWithRowAndSection:NSIndexPath?
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
//        audioPlayer.currentItem?.duration.seconds
        
        timer?.invalidate()
        timePlayer.text = "00:00"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "update", userInfo: nil, repeats: true)
        ifAutoFinish = true
        
        let pictureUrl = gequData[index]["picture"].string!
        getImageFromCache(pictureUrl, imageView: self.RorationImage)
        getImageFromCache(pictureUrl, imageView: self.blackGroundImageView)
        getImageFromCache(pictureUrl, imageView: currentPlayerImage)
        
        

        let current播放音乐歌名 = gequData[index]["title"].string
        self.currentPlayerBtn.setTitle(current播放音乐歌名, forState: .Normal)
        
    }

    
    func update(){

        let c = audioPlayer.currentTime().seconds
       
        if c > 0.0{  // c>0.0 必须判断

            let t = audioPlayer.currentItem!.duration.seconds
            //计算百分比
            let pro:CGFloat = CGFloat(c/t)
            progressBg.layer.frame.size.width = view.frame.size.width * pro
            
            self.slider.value = Float(pro)*100
          
            let intC = Int(c)
            let s = intC % 60
            let m = intC / 60
//            if m < 10{
//                time = "0\(m):"
//            }else{
//                time = "\(m):"
//            }
//            
//            if s < 10{
//                time += "0\(s)"
//            }else{
//                time += "\(s)"
//            }
            let resu = NSString(format: "%02d:%02d", m,s)
            
            timePlayer.text = resu as String
            
        }
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
//               关闭音乐波动动画，不然在下一视图中会卡顿
                self.animation音乐波动.GRAnimateStop()
                
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
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinishPlayer", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playItem)
        
        slider圆形初始化()
        currentPlayer背景设置()
        currentPlayerImage设置()
        
        animation音乐波动构造函数()
        currentPlayerBtn响应事件()
        
        
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

    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews")
    }
    override func viewDidLayoutSubviews() {
//        print(self.geQuLieBiao.frame)
        print("viewDidLayoutSubviews")
//        self.animation音乐波动.frame = self.geQuLieBiao.frame
    }
    override func viewDidAppear(animated: Bool) {
        print("viewdidappear")
        print(self.geQuLieBiao.frame)
        self.animation音乐波动.frame = self.geQuLieBiao.frame
//        animation音乐波动构造函数()
//        self.animation音乐波动.GRAnimateStart()
    }
    override func viewWillDisappear(animated: Bool) {
        print("viewWillDisappear")
    }
//*****************************************
// viewWillAppear
// 界面动画初始化
//
//*****************************************
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    
        RorationImage.stAnimation()
        if ifFirstLogin{
            ifFirstLogin = !ifFirstLogin
        }else{
            self.currentPlayerBtn.animateSpring(true)
        }

//      UIView动画的前奏设置
        self.RorationImage.transform = CGAffineTransformMakeScale(2, 2)
        self.RorationImage.layer.position.y = -210
        
        self.slider圆形容器.transform = CGAffineTransformMakeScale(2, 2)
        self.slider圆形容器.layer.position.y = -210

        self.StackView_Button.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 15, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.RorationImage.transform = CGAffineTransformMakeScale(1, 1)
            self.RorationImage.layer.position.y = 10 + 200
            
            self.slider圆形容器.transform = CGAffineTransformMakeScale(1, 1)
            self.slider圆形容器.layer.position.y = 10 + 200
            
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

        
        
        self.animation音乐波动.GRAnimateStart()
       
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
        cellIndexWithRowAndSection = indexPath
        cellIndex = indexPath.row

        self.pauseBtnn.isPlay = true
        self.pauseBtnn.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        self.animation音乐波动.GRAnimateStop()

        delay(0.2) { () -> () in
        self.animation音乐波动.GRAnimateStart()
        print("laile")
        }
     
    
        musicPlayerGR(indexPath.row)
        
    }
//    GCD
    func delay(second:Double,block:()->()){
        let Second = second * Double(NSEC_PER_SEC)  //0指等待0秒播放动画
        let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(Second))
        dispatch_after(dtime, dispatch_get_main_queue(), block)
    }


    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.5) { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
   
//*****************************************
// currentPlayer背景设置
//
//
//*****************************************
    func currentPlayer背景设置(){
        currentPlayer背景.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
//        currentPlayer背景.backgroundColor = UIColor.clearColor()
//        父视图设置alpha时候，会对子视图产生影响。
//        currentPlayer背景.layer.opacity = 1
//      currentPlayer背景.alpha = 1 效果一样，设置之后对整个视图包括子视图都被更改
        
    }
    func currentPlayerImage设置(){
        currentPlayerImage.layer.cornerRadius = 10
        currentPlayerImage.layer.masksToBounds = true
        //currentPlayerImage.contentMode = .ScaleAspectFill  与下面一样
        currentPlayerImage.layer.contentsGravity = kCAGravityResizeAspectFill
        currentPlayerImage.layer.borderColor = UIColor(red: 95/255, green: 222/255, blue: 68/255, alpha: 1).CGColor
        currentPlayerImage.layer.borderWidth = 3
    }
    
    func animation音乐波动构造函数(){
        
        animation音乐波动 = GRMusicAnimation(rect: self.geQuLieBiao.frame, number: 30)
        self.view.addSubview(animation音乐波动)
        self.view.bringSubviewToFront(geQuLieBiao)
//        animation音乐波动.setNeedsLayout()
//        animation音乐波动.setNeedsUpdateConstraints()
        self.view.sendSubviewToBack(blackGroundImageView)
        
        
    }
    func currentPlayerBtn响应事件(){
        currentPlayerBtn.addTarget(self, action: "btn响应事件", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
 
    func btn响应事件(){
        
    }
    
    
}

