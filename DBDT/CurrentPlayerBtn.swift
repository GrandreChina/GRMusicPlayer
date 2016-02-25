//
//  CurrentPlayerBtn.swift
//  DBDT
//
//  Created by Grandre on 16/1/22.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
import QuartzCore

class CurrentPlayerBtn: UIButton {
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: UIControlState.Normal)

//        之所以把播放动画放在这里，因为想满足，当歌名即title改变的时候，重写触发动画
            self.titleLabel?.layer.removeAllAnimations()
        
            self.animateSpring(true)
        
    }

//    override func drawRect(rect: CGRect) {
////        self.layer.backgroundColor = UIColor.clearColor().CGColor
////        self.backgroundColor = UIColor.clearColor()
////        self.titleLabel?.backgroundColor = UIColor.clearColor()
////        self.layer.backgroundColor = UIColor.clearColor().CGColor
////        self.titleLabel?.layer.backgroundColor = UIColor.clearColor().CGColor
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitle("grandre", forState: UIControlState.Normal)
        self.setTitleColor(UIColor.redColor(), forState: .Normal)
        self.titleLabel?.font = UIFont(name: "CourierNewPS-BoldMT", size: 20)
//        MarkerFelt-Thin
//        Chalkduster
//        自动调整字体大小以显示全部title内容
//        self.titleLabel?.adjustsFontSizeToFitWidth = true
//        当内容过长时，又不想自动调整大小。可以采用storyboard中不指定btn的右边约束。再使用translation动画显示全部内容。
        
//        self.contentHorizontalAlignment = .Left
//        self.titleLabel?.textAlignment = .Left  没用
        
//        裁剪多出的歌曲名
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        self.layer.cornerRadius = 10
//        self.titleLabel?.backgroundColor = UIColor.clearColor()
//        self.layer.backgroundColor = UIColor.clearColor().CGColor
//        self.titleLabel?.layer.backgroundColor = UIColor.clearColor().CGColor
    
        
    }

    
    var ifAutoFinish动画:Bool = false
    
    func animate歌名动画(play:Bool){
        self.titleLabel?.layer.removeAllAnimations()
        ifAutoFinish动画 = false
        performSelector("translationAni", withObject: nil, afterDelay: 0.3)

    }
    func translationAni(){
        let ani = CABasicAnimation(keyPath: "position.x")
        ani.fromValue = self.frame.width + self.center.x
        ani.toValue = -self.center.x
        
        //        设置了之后动画竟然无效
        //        ani.beginTime = 4
        
        ani.duration = 10
        ani.removedOnCompletion = true
        ani.repeatCount = 1000
        ani.removedOnCompletion = false
        ani.fillMode = kCAFillModeForwards
        ani.delegate = self
        ani.setValue("2", forKey: "whichAnimation")
        self.titleLabel!.layer.addAnimation(ani, forKey: "1")
        ifAutoFinish动画 = true
        
    }
    func animateSpring(play:Bool){
        ifAutoFinish动画 = false
        self.titleLabel?.layer.removeAllAnimations()

        performSelector("sprintAni", withObject: nil, afterDelay: 0.2)
    }
    
    func sprintAni(){
        let sprintAni = CASpringAnimation(keyPath: "position.x")
        sprintAni.damping = 10
        sprintAni.mass = 2
        sprintAni.stiffness = 200
        sprintAni.initialVelocity = 4
        sprintAni.fromValue = self.bounds.width + (self.titleLabel?.layer.position.x)!
        sprintAni.toValue = self.center.x
        
        sprintAni.duration = 3
        sprintAni.fillMode = kCAFillModeBackwards
        sprintAni.removedOnCompletion = false
        sprintAni.delegate = self
        sprintAni.setValue("1", forKey: "whichAnimation")
        self.titleLabel!.layer.addAnimation(sprintAni, forKey: "111")
        ifAutoFinish动画 = true
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("animation stop")
//        self.transform = CGAffineTransformIdentity
//        self.layer.transform = CATransform3DIdentity
        if ifAutoFinish动画{
            switch anim.valueForKey("whichAnimation") as! String{
            case "1":print(" 11")
                animate歌名动画(true)
            case "2":print("22")
//                animate歌名动画(true)
            default:print("33")

            }
        }
    }
}
