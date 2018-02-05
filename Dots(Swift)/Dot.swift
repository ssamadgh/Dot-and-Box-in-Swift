//
//  Dot.swift
//  Dots(Swift)
//
//  Created by Seyed Samad Gholamzadeh on 9/19/1394 AP.
//  Copyright © 1394 AP Seyed Samad Gholamzadeh. All rights reserved.
//

import UIKit

class Dot: NSObject {
    
    var point: CGPoint!
    var location: CGPoint!
    
    override var description : String {
        
        return "(\(self.point.x),\(self.point.y))"

    }
    

}
