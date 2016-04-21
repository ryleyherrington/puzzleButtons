//
//  ViewController.swift
//  Puzzle Buttons
//
//  Created by Ryley Herrington on 4/9/16.
//  Copyright © 2016 Herrington. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var n:Int = 3 //number of rows / columns
    var width:CGFloat = 0
    var height:CGFloat = 0
    var nonhighlighted = UIColor ( red: 0.4789, green: 0.0, blue: 0.4788, alpha: 1.0 )
    var highlighted    = UIColor.whiteColor()
    var onArr:[Bool] = []
    var buttonArray:[UIButton] = []
    var movesStack:[Int] = []
    
    //IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.width  = self.view.frame.size.width
        self.height = self.containerView.frame.size.height
        
        setupButtons()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //IBActions
    @IBAction func indexChanged(sender:UISegmentedControl) {
        switch seg.selectedSegmentIndex {
        case 0:
            self.n = 3
            
        case 1:
            self.n = 4
            
        case 2:
            self.n = 5
            
        default:
            self.n = 3
            break;
        }
    }
    
    @IBAction func resetGame(sender: AnyObject) {
        removeAllButtons()
        setupButtons()
    }
    
    @IBAction func startGame(sender: AnyObject) {
        removeAllButtons()
        setupButtons()
        let upper = UInt32((n*n)-1)
        for _ in 0...n {
            let b = buttonArray[Int(arc4random_uniform(upper))]
            print("Touched \(b.tag)")
            b.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    @IBAction func undo(sender: AnyObject) {
        if self.movesStack.last != nil {
            let b = buttonArray[self.movesStack.last!]
            self.movesStack.removeLast()
            b.sendActionsForControlEvents(.TouchUpInside)
            self.movesStack.removeLast()
        }
    }
    
    func removeAllButtons() {
        for b in self.buttonArray {
            b.removeFromSuperview()
        }
        
        self.buttonArray.removeAll()
        self.onArr.removeAll()
        self.movesStack.removeAll()
    }
    
    func createAndAddButton(index:Int, row:Int, w:CGFloat, h:CGFloat) ->UIButton{
        let button = UIButton(type: .System)
        
        let x = (10.0*(CGFloat(index%n)))+CGFloat((CGFloat(index % n)+1.0)*w) - w
        let y = CGFloat((row)*90)
        
        button.frame = CGRectMake(x, y, w, h)
        button.backgroundColor = self.nonhighlighted
        button.accessibilityLabel = "\(index)"
        button.tag = index
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(ViewController.buttonTouched(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.containerView.addSubview(button)
        return button
    }

    func setupButtons() {
        let w = (width-(10.0*(CGFloat(n)+1.0)))/CGFloat(n)
        let h = CGFloat(80.0)
        
        for i in 0..<n*n {
//            print("i:\(i) n=\(n), i%n = \(i%n), row=\(trunc(Double(i/n)))")
            self.buttonArray.append(createAndAddButton(i, row: Int(trunc(Double(i/n))), w:w, h:h))
            onArr.append(false)
        }
    }
   
    func toggleButton(index:Int) {
        let button = buttonArray[index]
        if button.backgroundColor == self.nonhighlighted {
            button.backgroundColor = self.highlighted
            onArr[index] = true
        } else {
            button.backgroundColor = self.nonhighlighted
            onArr[index] = false
        }
        
    }
    
    func buttonTouched(sender:UIButton){
        self.movesStack.append(sender.tag)
        
        toggleButton(sender.tag)
        if isLeftEdge(sender.tag) {
            changeLeft(sender.tag)
        } else if isRightEdge(sender.tag){
            changeRight(sender.tag)
        } else {
            changeMiddle(sender.tag)
        }
        
        
        checkWin()
    }
    
    func isLeftEdge(index:Int) -> Bool {
        if (index%n == 0) {
            return true
        }
        return false
    }
    
    func changeLeft(index:Int) {
        if index - n >= 0 {
            toggleButton(index-n)
        }
        if index + n < n*n {
            toggleButton(index+n)
        }
        toggleButton(index+1)
    }
   
    func isRightEdge(index:Int) -> Bool {
        if (index%n == n-1) {
            return true
        }
        return false
    }
    
    func changeRight(index:Int) {
        if index - n >= 0 {
            toggleButton(index-n)
        }
        if index + n < n*n {
            toggleButton(index+n)
        }
        toggleButton(index-1)
    }
   
    func changeMiddle(index:Int) {
        if index - n >= 0 {
            toggleButton(index-n)
        }
        if index + n < n*n {
            toggleButton(index+n)
        }
        toggleButton(index-1)
        toggleButton(index+1)
    }
    
    func checkWin() {
        for b in self.onArr {
            if b == false {
                return
            }
        }
        
        //They won
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let winningVC = storyboard.instantiateViewControllerWithIdentifier("WinningViewController") as! WinningViewController
        winningVC.shareText = "Hey, I just won my puzzlebuttons game in \(self.movesStack.count) moves!"
        winningVC.movesList = "\(self.movesStack)"
        winningVC.moves = "\(self.movesStack.count) moves!"
        
        //get screenshot
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        winningVC.backgroundImg = screenshot

        self.presentViewController(winningVC, animated: false, completion: nil)
    }
}

