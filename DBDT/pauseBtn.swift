//
//  pauseBtn.swift
//  DBDT
//
//  Created by Grandre on 16/1/5.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class pauseBtn: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         self.addTarget(self, action: "isChangeState", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    var isPlay:Bool = true
    let imgPlay:UIImage = UIImage(named: "play")!
    let imgPause:UIImage = UIImage(named: "pause")!
    
//    func isPlayState(){
//        isPlay = true
//        self.setImage(imgPause, forState: UIControlState.Normal)
//    }
    
    func isChangeState(){
        isPlay = !isPlay
        if isPlay{
            self.setImage(imgPause, forState: UIControlState.Normal)
        }else{
            self.setImage(imgPlay, forState: UIControlState.Normal)
        }
    }

}
