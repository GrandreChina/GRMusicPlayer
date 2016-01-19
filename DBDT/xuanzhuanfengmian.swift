//
//  xuanzhuanfengmian.swift
//  DBDT
//
//  Created by Grandre on 16/1/1.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class xuanzhuanfengmian: UIImageView {

//    继承后给属性赋值，要写这里面。或是用属性观察者。
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//
        layer.cornerRadius = self.frame.width/2
        layer.masksToBounds = true
        
        layer.borderWidth = 3
        layer.borderColor = UIColor.grayColor().CGColor
        
        self.stAnimation()
       
    }
    
    
    
    func stAnimation(){
        let ani = CABasicAnimation(keyPath: "transform.rotation")
//    以下三项决定速度
        ani.fromValue = 0.0
        ani.toValue = M_PI*2.0
        ani.duration = 20
//  以下一项决定转动的圈数
        ani.repeatCount = 10000
        self.layer.addAnimation(ani, forKey:nil)
   
    }

    
    
    
    
}
