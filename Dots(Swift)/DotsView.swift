//
//  DotsView.swift
//  Dots(Swift)
//
//  Created by Seyed Samad Gholamzadeh on 9/19/1394 AP.
//  Copyright © 1394 AP Seyed Samad Gholamzadeh. All rights reserved.
//

import UIKit
import AVFoundation

class DotsView: UIView {
    
    var dotArray: Array<Dot>
    var lineArray: Array<Line>
    var boxArray: Array<Box>
    var currentLine: Line!
    var lineLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        self.dotArray = Array<Dot>()
        self.lineArray = Array<Line>()
        self.boxArray = Array<Box>()
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        let xCount = 4
        let yCount = 4
        let size = (frame.size.width - 80) / CGFloat(xCount - 1)
        var y = 80
        for i in 0  ..< xCount {
            var x = 40
            
            for j in 0  ..< yCount {
                
                let dot = Dot()
                dot.location = CGPoint(x: CGFloat(x), y: CGFloat(y))
                dot.point = CGPoint(x: CGFloat(j), y: CGFloat(i))
                print("dot is \(dot)\n")
                self.dotArray.append(dot)
                print("dotArray is \(self.dotArray)\n")
                x += Int(size)
            }
            y += Int(size)
            
        }
        
        for i in 0  ..< xCount {
            for j in 0  ..< yCount {
                
                if i < (xCount - 1) {
                    self.createLineFrom(CGPoint(x: CGFloat(i), y: CGFloat(j)), To: CGPoint(x: CGFloat(i+1), y: CGFloat(j)))
                }
                if j < (yCount - 1) {
                    self.createLineFrom(CGPoint(x: CGFloat(i), y: CGFloat(j)), To: CGPoint(x: CGFloat(i), y: CGFloat(j+1)))
                }
            }
        }
        
        
        for i in 0  ..< xCount {
            for j in 0  ..< yCount {
                
                if i < (xCount - 1) && j < (yCount - 1) {
                    self.createBoxFrom(CGPoint(x: CGFloat(i), y: CGFloat(j)))
                }
            }
        }
                
        //NNNN this lines are about line animations:
        self.lineLayer = CAShapeLayer(layer: layer)
        self.lineLayer.backgroundColor = UIColor.clear.cgColor
        self.lineLayer.strokeColor = UIColor.darkGray.cgColor
        self.lineLayer.lineWidth = 8
        self.lineLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.addSublayer(self.lineLayer)
        self.newGame()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLine(_ line: Line) {
        let fromPath = UIBezierPath()
        fromPath.move(to: line.endpoint2.location)
        fromPath.addLine(to: line.endpoint1.location)
        
        let toPath = UIBezierPath()
        toPath.move(to: line.endpoint2.location)
        toPath.addLine(to: line.endpoint2.location)
        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.fromValue = fromPath.cgPath
        pathAnim.toValue = toPath.cgPath
        pathAnim.duration = 0.5
        self.lineLayer.add(pathAnim, forKey: "pathAnimation")
        self.lineLayer.setNeedsDisplay()
    }
    
    func computerPlay() {
        print("computerPlay")
        let newLine = self.selectAline()
        if newLine != nil && newLine?.lineType == LineType.lineTypeEmpty {
            self.animateLine(newLine!)
            newLine?.lineType = LineType.lineTypePlayer2
            if self.checkAndSetBoxComplete(newLine!, playerType: PlayerType.playerType2) {
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DotsView.computerPlay), userInfo: nil, repeats: false)
                if self.gameOver() {
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DotsView.checkGameOver), userInfo: nil, repeats: false)
                }
            }
            self.setNeedsDisplay()
        }
    }
    
    func checkGameOver() {
        if self.gameOver() {
            if self.player1Won() {
                print("You won!!")
                self.newGame()
            } else {
                print("I won!!")
                self.newGame()

            }
        }
    }
    
    func tapAtPoint(_ point:CGPoint) {
        let line = self.currentLine
        if line != nil && line!.lineType == LineType.lineTypeEmpty {
            line?.lineType = LineType.lineTypePlayer1
            var completed = false
            if self.checkAndSetBoxComplete(line!, playerType: PlayerType.playerType1) {
                completed = true
                self.checkGameOver()
            }
//            self.setNeedsDisplay()
            
            if !completed {
                self.computerPlay()
            }
        }
    }
    
    func findDot(_ point: CGPoint) -> Dot? {
        
        for dot in self.dotArray {
            if dot.point.equalTo(point) {
                return dot
            }
        }
        return nil
    }
    
    func findLine(_ p1: CGPoint, To p2: CGPoint) -> Line? {
        for line in self.lineArray {
            if p1.equalTo(line.endpoint1.point) && p2.equalTo(line.endpoint2.point) {
                return line
            }
        }
        return nil
    }

    
    func findLineAtLocation(_ point: CGPoint) -> Line? {
        for line in self.lineArray {
            let rect = line.getTouchRect()
            if rect.contains(point) {
                return line
            }
        }
        return nil
    }
    
    func createLineFrom(_ p1: CGPoint, To p2: CGPoint) {
        
        let line = Line(WithEndpoint1: self.findDot(p1)!, endpoint2: self.findDot(p2)!)
        self.lineArray.append(line)
        print("lineArray is \(self.lineArray)\n")
    }
    
    func createBoxFrom(_ point: CGPoint) {
        let box = Box()
        let p1 = point
        let p2 = CGPoint(x: point.x + 1, y: point.y)
        let p3 = CGPoint(x: point.x + 1, y: point.y + 1)
        let p4 = CGPoint(x: point.x, y: point.y + 1)
        box.top = self.findLine(p1, To: p2)
        box.right = self.findLine(p2, To: p3)
        box.left = self.findLine(p1, To: p4)
        box.bottom = self.findLine(p4, To: p3)
        self.boxArray.append(box)
        print("boxArray is \(self.boxArray)\n")
    }

    func checkAndSetBoxComplete(_ line: Line, playerType type: PlayerType) -> Bool {
        var completeCount = 0
        for box in boxArray {
            if box.boxType == BoxType.boxTypeEmpty && box.boxContainsLine(line) {
                box.checkAndSetTypeOfCompletedBox(type)
                if box.boxType != BoxType.boxTypeEmpty {
                    completeCount += 1
                }
            }
        }
        return completeCount > 0
    }
    
    func gameOver() -> Bool {
        
        for box in self.boxArray {
            if box.boxType == BoxType.boxTypeEmpty {
                return false
            }
        }
        return true
    }
    
    func player1Won() -> Bool {
        var count1 = 0
        var count2 = 0
        for box in self.boxArray {
            if box.boxType == BoxType.boxTypePlayer1 {
                count1 += 1
            } else if box.boxType == BoxType.boxTypePlayer2 {
                count2 += 1
            }
        }
        return count1 >= count2
    }
    
    func selectAline() -> Line? {
        var one = [Line]()
        var two = [Line]()
        var three = [Line]()
        var four = [Line]()
        for box in self.boxArray {
            var emptyLines = 0
            if box.top.lineType == LineType.lineTypeEmpty  {
                emptyLines += 1
            }
            if box.left.lineType == LineType.lineTypeEmpty  {
                emptyLines += 1
            }
            if box.right.lineType == LineType.lineTypeEmpty  {
                emptyLines += 1
            }
            if box.bottom.lineType == LineType.lineTypeEmpty  {
                emptyLines += 1
            }
            
            switch emptyLines {
            case 1:
                if box.top.lineType == LineType.lineTypeEmpty  {
                    one.append(box.top)
                }
                if box.left.lineType == LineType.lineTypeEmpty  {
                    one.append(box.left)
                }
                if box.right.lineType == LineType.lineTypeEmpty  {
                    one.append(box.right)
                }
                if box.bottom.lineType == LineType.lineTypeEmpty  {
                    one.append(box.bottom)
                }
            case 2:
                if box.top.lineType == LineType.lineTypeEmpty  {
                    two.append(box.top)
                }
                if box.left.lineType == LineType.lineTypeEmpty  {
                    two.append(box.left)
                }
                if box.right.lineType == LineType.lineTypeEmpty  {
                    two.append(box.right)
                }
                if box.bottom.lineType == LineType.lineTypeEmpty  {
                    two.append(box.bottom)
                }
            case 3:
                if box.top.lineType == LineType.lineTypeEmpty  {
                    three.append(box.top)
                }
                if box.left.lineType == LineType.lineTypeEmpty  {
                    three.append(box.left)
                }
                if box.right.lineType == LineType.lineTypeEmpty  {
                    three.append(box.right)
                }
                if box.bottom.lineType == LineType.lineTypeEmpty  {
                    three.append(box.bottom)
                }
            case 4:
                if box.top.lineType == LineType.lineTypeEmpty  {
                    four.append(box.top)
                }
                if box.left.lineType == LineType.lineTypeEmpty  {
                    four.append(box.left)
                }
                if box.right.lineType == LineType.lineTypeEmpty  {
                    four.append(box.right)
                }
                if box.bottom.lineType == LineType.lineTypeEmpty  {
                    four.append(box.bottom)
                }
            default: break
            }
            
        }
        
        var count = one.count
        if count >= 1 {
            let index = Int(arc4random_uniform(UInt32(count)))
            return one[index]
        }
        count = four.count
        if count >= 1 {
            let index = Int(arc4random_uniform(UInt32(count)))
            return four[index]
        }
        count = three.count
        if count >= 1 {
            let index = Int(arc4random_uniform(UInt32(count)))
            return three[index]
        }
        count = two.count
        if count >= 1 {
            let index = Int(arc4random_uniform(UInt32(count)))
            return two[index]
        }
        return nil
    }
    
    func newGame() {
        for line in self.lineArray {
            line.lineType = LineType.lineTypeEmpty
        }
        for box in  boxArray {
            box.boxType = BoxType.boxTypeEmpty
        }
        
        let stepAnim = CABasicAnimation(keyPath: "position")
        let x = self.layer.frame.size.width/2
        stepAnim.fromValue = NSValue(cgPoint: CGPoint(x: x, y: -(self.layer.frame.size.height / 2.0)))
        stepAnim.toValue = NSValue(cgPoint: CGPoint(x: x, y: (self.layer.frame.size.height / 2.0)))
        stepAnim.duration = 1
        self.setNeedsDisplay()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        let location = t!.location(in: self)
        let line = findLineAtLocation(location)
        if line != nil {
            self.currentLine = line
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        let t = touches.first
        let point = t!.location(in: self)
        self.tapAtPoint(point)
        self.currentLine = nil
        self.setNeedsDisplay()
    }
    
    func strokeDot(_ dot: Dot) {
        
        // Ebony Clay #22313F
        let dotColor = UIColor(red: 34.0/255.0, green: 49/255.0, blue: 62/255.0, alpha: 1)
        dotColor.setFill()
        UIColor.darkGray.setStroke()
        let bp = UIBezierPath()
        bp.lineWidth = 2
        bp.lineCapStyle = CGLineCap.square
        bp.addArc(withCenter: dot.location, radius: 5, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        bp.fill()
        bp.addArc(withCenter: dot.location, radius: 6, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        bp.stroke()
    }
    
    func strokeLine(_ line: Line) {
        let bp = UIBezierPath()
        bp.lineWidth = 8
        bp.lineCapStyle = CGLineCap.round
        bp.move(to: line.endpoint1.location)
        bp.addLine(to: line.endpoint2.location)
//        UIColor.darkGrayColor().setStroke()
        bp.stroke()
    }
    
    func strokeBox(_ box: Box) {
        let bp = UIBezierPath()
        bp.move(to: box.top.endpoint1.location)
        bp.addLine(to: box.top.endpoint2.location)
        bp.addLine(to: box.right.endpoint2.location)
        bp.addLine(to: box.left.endpoint2.location)
        bp.addLine(to: box.left.endpoint1.location)
//        UIColor.darkGrayColor().setFill()
        bp.fill()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        print("drawRect")
        
        for dot in self.dotArray {
            self.strokeDot(dot)
        }

        for box in self.boxArray {
            if box.boxType == BoxType.boxTypePlayer1 {
                // Piction Blue #22A7F0
                let boxColor1 = UIColor(red: 34.0/255.0, green: 168.0/255.0, blue: 240.0/255.0, alpha: 1)
                boxColor1.setFill()
                self.strokeBox(box)
            } else if box.boxType == BoxType.boxTypePlayer2 {
                // Fire Bush #EB9532
                let boxColor2 = UIColor(red: 235/255, green: 149/255, blue: 50/255, alpha: 1)
                boxColor2.setFill()
                self.strokeBox(box)
            }
        }
        
        for line in self.lineArray {
            
            if line.lineType == LineType.lineTypePlayer1 {
                // Jelly Bean #2574A9
                let lineColor1 = UIColor(red: 37/255, green: 116/255, blue: 169/255, alpha: 1)
                lineColor1.setStroke()
                self.strokeLine(line)
            } else if line.lineType == LineType.lineTypePlayer2 {
                // Burnt Orange #D35400
                let lineColor2 = UIColor(red: 211/255, green: 84/255, blue: 0/255, alpha: 1)
                lineColor2.setStroke()
                self.strokeLine(line)
            }
        }
        
        // Ebony Clay #22313F
        let currentLineColor = UIColor(red: 34.0/255, green: 49.0/255, blue: 63.0/255, alpha: 1)
        currentLineColor.setStroke()
        if self.currentLine != nil {
            self.strokeLine(self.currentLine)
        }
    }
    


}
