//
//  BlueEffectImageViewClass.swift
//  DBDT
//
//  Created by Grandre on 16/1/2.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class BlueEffectImageViewClass: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UIView.animateWithDuration(0) { () -> Void in
            self.blueEffect()        
        }
    }

    
    func blueEffect(){
        let blueE = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blueEV = UIVisualEffectView(effect: blueE)
        blueEV.frame = UIScreen.mainScreen().bounds
        self.addSubview(blueEV)
    }

}
