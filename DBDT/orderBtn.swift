//
//  orderBtn.swift
//  DBDT
//
//  Created by Grandre on 16/1/6.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class orderBtn: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: "setImageFromOrder", forControlEvents: UIControlEvents.TouchUpInside)
    }
    let order1 = UIImage(named: "order1")
    let order2 = UIImage(named: "order2")
    let order3 = UIImage(named: "order3")
    
    var order:Int = 1
    
    func setImageFromOrder(){
        order++
        if order == 2{
            self.setImage(order2, forState: UIControlState.Normal) //随机
        }else if order == 3{
            self.setImage(order3, forState: UIControlState.Normal) //单曲
        }else if order > 3{
            order = 1
            self.setImage(order1, forState: UIControlState.Normal)//顺序
        }
    }
    
}
