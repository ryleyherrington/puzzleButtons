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
    var shareGame:[Int]  = []
    
    //IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width  = self.view.frame.size.width
        height = self.containerView.frame.size.height
        
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
        case 0: //Easy
            n = 3
            
        case 1: //Hard
            n = 4
            
        default:
            n = 3
            break;
        }
        
        resetHelper()
    }
  
    func resetHelper(){
        removeAllButtons()
        setupButtons()
        movesStack.removeAll()
        shareGame.removeAll()
    }
    
    @IBAction func resetGame(sender: AnyObject) {
        resetHelper()
    }
    
    @IBAction func startGame(sender: AnyObject) {
        removeAllButtons()
        setupButtons()
        let upper = UInt32((n*n)-1)
        for _ in 0...n {
            let b = buttonArray[Int(arc4random_uniform(upper))]
            b.sendActionsForControlEvents(.TouchUpInside)
        }
        shareGame = movesStack
        movesStack.removeAll()
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        share(false)
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
        
        let x = 5+(10.0*(CGFloat(index%n)))+CGFloat((CGFloat(index % n)+1.0)*w) - w
        let y = CGFloat(row)*(h + 5)
        
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
        let h = self.containerView.frame.size.height/(CGFloat(n)+1.3)
        
        for i in 0..<n*n {
//            print("i:\(i) n=\(n), i%n = \(i%n), row=\(trunc(Double(i/n)))")
            self.buttonArray.append(createAndAddButton(i, row: Int(trunc(Double(i/n))), w:w, h:h))
            onArr.append(false)
        }
    }
   
    func toggleButton(index:Int) {
        let button = buttonArray[index]
        let origFrame = button.frame
        
        UIView.animateWithDuration(0.3, animations: {
            button.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, 0, origFrame.size.height)
        }) { (_) in
            if button.backgroundColor == self.nonhighlighted {
                button.backgroundColor = self.highlighted
                self.onArr[index] = true
            } else {
                button.backgroundColor = self.nonhighlighted
                self.onArr[index] = false
            }
            
            UIView.animateWithDuration(0.3, animations: { 
                button.frame = origFrame
            })
            
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.checkWin()
        }
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
        
        //they must've won
        share(true)
    }
    
    func share(didWin:Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let winningVC = storyboard.instantiateViewControllerWithIdentifier("WinningViewController") as! WinningViewController
        
        var beginGame = "\(self.shareGame)"
            beginGame = beginGame.stringByReplacingOccurrencesOfString("[", withString: "")
            beginGame = beginGame.stringByReplacingOccurrencesOfString("]", withString: "")
            beginGame = beginGame.stringByReplacingOccurrencesOfString(",", withString: "")
            beginGame = beginGame.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        if didWin {
            winningVC.titleString = "Congratulations"
            if shareGame.count < 1 {
            winningVC.shareText = "Hey, I just won my \(n)x\(n)puzzlebuttons game in \(self.movesStack.count) moves!"
            } else {
                winningVC.shareText = "Hey, I just won Game:\(n)\(beginGame)puzzlebuttons game in \(self.movesStack.count) moves!"
            }
            winningVC.movesList = "\(movesStack)"
        } else {
            winningVC.titleString = "Share this game!"
            winningVC.shareText = "puzzleButtons://\(n)\(shareGame)"
            winningVC.movesList = "Game #:\(beginGame)"
        }
        
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

