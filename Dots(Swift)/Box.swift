//
//  Box.swift
//  Dots(Swift)
//
//  Created by Seyed Samad Gholamzadeh on 9/19/1394 AP.
//  Copyright © 1394 AP Seyed Samad Gholamzadeh. All rights reserved.
//

import UIKit

enum BoxType {
   case boxTypeEmpty,
        boxTypePlayer1,
        boxTypePlayer2
}

class Box: NSObject {
    
    var top: Line!
    var right: Line!
    var bottom: Line!
    var left: Line!
    var boxType: BoxType!
    
    func boxContainsLine(_ line: Line) -> Bool {
        
        if (line == self.top) {
            return true;
        } else if (line == self.right) {
            return true;
        } else if (line == self.bottom) {
            return true;
        } else if (line == self.left) {
            return true;
        }
        return false;        
    }
    
    func checkAndSetTypeOfCompletedBox(_ playerType: PlayerType) {
        
        if self.top.lineType != LineType.lineTypeEmpty && self.right.lineType != LineType.lineTypeEmpty && self.left.lineType != LineType.lineTypeEmpty && self.bottom.lineType != LineType.lineTypeEmpty {
            
            if playerType == PlayerType.playerType1 {
                self.boxType = BoxType.boxTypePlayer1
            } else  if playerType == PlayerType.playerType2 {
                
                self.boxType = BoxType.boxTypePlayer2
            }
        }
    }
    
    override var description : String {
        
        return "Box type \(self.boxType) at top \(self.top)"
    }
    
}
