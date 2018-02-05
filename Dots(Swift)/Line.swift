//
//  Line.swift
//  Dots(Swift)
//
//  Created by Seyed Samad Gholamzadeh on 9/19/1394 AP.
//  Copyright © 1394 AP Seyed Samad Gholamzadeh. All rights reserved.
//

import Foundation
import UIKit

enum PlayerType {
    
    case playerType1, playerType2
}

enum LineType {
    case lineTypeEmpty, lineTypePlayer1, lineTypePlayer2
}
class Line: NSObject {
    
    var endpoint1: Dot!
    var endpoint2: Dot! 
    var toachRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var lineType: LineType!
    
    init(WithEndpoint1 dot1: Dot,endpoint2 dot2:Dot) {
        
        self.endpoint1 = dot1
        self.endpoint2 = dot2
        
    }
    
    
    func getTouchRect() -> CGRect {
        
        let offset = 5
        var margin = 0
        if self.toachRect.isEmpty {
            if self.endpoint1.location.x == self.endpoint2.location.x {
                margin = Int(self.endpoint2.location.y - self.endpoint1.location.y)/3
                self.toachRect = CGRect(x: self.endpoint1.location.x - CGFloat(margin) , y: self.endpoint1.location.y + CGFloat(offset), width: CGFloat(margin) * 2, height: self.endpoint2.location.y - self.endpoint1.location.y - CGFloat(offset) - CGFloat(offset))
            } else {
                margin = Int(self.endpoint2.location.x - self.endpoint1.location.x)/3
                self.toachRect = CGRect(x: self.endpoint1.location.x + CGFloat(offset), y: self.endpoint1.location.y - CGFloat(margin), width: self.endpoint2.location.x - self.endpoint1.location.x - CGFloat(offset) - CGFloat(offset), height: CGFloat(margin) * 2);
            }

        }
        
        return self.toachRect
    }
    
    override var description : String {
        
        return "Line at \(self.endpoint1),\(self.endpoint2)"
        
    }
    

}
