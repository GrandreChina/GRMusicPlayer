//
//  progressView.swift
//  DBDT
//
//  Created by Grandre on 16/1/6.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class progressView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.borderWidth = 5
        layer.borderColor = UIColor.grayColor().CGColor
        layer.cornerRadius = self.frame.width / 2
        layer.masksToBounds = true
        progressView(8)
    }
    
    func progressView(time:NSTimeInterval){
            UIView.animateWithDuration(time) { () -> Void in
           
        }
    }
}
