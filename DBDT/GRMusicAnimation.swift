//
//  MyView.swift
//  AddSubViewByCode
//
//  Created by Grandre on 16/1/23.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class GRMusicAnimation: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
//下面这个构造器的内容是在 storyboard中拖了一个UIView，再自定义一个UIView子类，然后把storyboard中的此UIView的类指定为自定义类时起作用。
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.layer.backgroundColor = UIColor.greenColor().CGColor
//        self.layer.frame = CGRectMake(100, 100, 200, 200)
//        self.layer.backgroundColor = UIColor.clearColor().CGColor
//        self.addSubviews(5)
//        self.animate(5)
        
    }
//    下面的构造器内容在纯代码实例化对象时起作用。
//添加指定构造器
    var number柱数全局变量:Int!
    
    init(rect: CGRect,number: Int){
        super.init(frame: rect)
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        self.addSubviews(number)
        
        number柱数全局变量 = number
        
    }
    
    var colorArr2:[UIColor]!
    
    func addSubviews(number柱数: Int){

        let 柱宽 = self.frame.width * 7/8 * 1/CGFloat(number柱数)
        let 杠宽 = self.frame.width * 1/8 * 1/CGFloat(number柱数+1)
        
//        let colorArr = [UIColor.purpleColor(),UIColor.greenColor(),UIColor.blueColor(),UIColor.redColor(),UIColor.blackColor()]
        
        colorArr2 = [(111,222,68),(177,137,227),(208,223,137),(208,69,81),(41,191,173)].map { (r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor in
            
            UIColor(red: r/255, green: g/255, blue: b/255, alpha: 0.3)
        }
        
        
        for i in (1...number柱数){
            let x = 杠宽 * CGFloat(i) + 柱宽 * CGFloat(i-1)

            let sb = UIView(frame: CGRectMake(x,0,柱宽,self.frame.height))
            sb.backgroundColor = colorArr2[(i-1)%5]
            sb.tag = i
            self.addSubview(sb)
        }
    }
    
    var ifAutoFinish = false
    func GRAnimateStart(){
        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            for i in (1...self.number柱数全局变量){
                
                self.viewWithTag(i)?.layer.frame.size.height = CGFloat(random())%self.frame.size.height
                self.viewWithTag(i)?.backgroundColor = self.colorArr2[random()%self.colorArr2.count]
                
                self.ifAutoFinish = true
            }
            
            }) { (finish) -> Void in
                if self.ifAutoFinish{
                    self.GRAnimateStart()
//                    print("重复波动动画")
                }else{
//                    print("关闭波动动画")
                }
        }
    }
    
    func GRAnimateStop(){
        self.ifAutoFinish = false
        for i in (1...number柱数全局变量){
            self.viewWithTag(i)?.layer.removeAllAnimations()
//            由于UIView动画终止时保持末状态，所以可以手动设置一下末状态高度。
            self.viewWithTag(i)?.layer.frame.size.height = 5
        }
    }
}
