//
//  HTTPController.swift
//  DBDT
//
//  Created by Grandre on 16/1/4.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
import Alamofire

class HTTPController: NSObject {
    var delegate:HTTPProtocol?
    func onSearch(url:String){
        Alamofire.request(.GET, url).responseJSON { (Response) -> Void in
//            
//            print(Response.request)  // original URL request
//            print(Response.response) // URL response
//            print(Response.data)     // server data
            print(Response.result)
            if let JSON = Response.result.value {
//                print("JSON: \(JSON)")
                self.delegate!.didReceiveResults(JSON)
            }
        }
    }
}
protocol HTTPProtocol{
    func didReceiveResults(result:AnyObject)
}
