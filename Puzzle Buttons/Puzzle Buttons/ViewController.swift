//
//  ViewController.swift
//  Puzzle Buttons
//
//  Created by Ryley Herrington on 4/9/16.
//  Copyright © 2016 Herrington. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var n:Int = 4 //number of rows / columns
    var width:CGFloat = 0
    var height:CGFloat = 0
    var nonhighlighted = UIColor ( red: 0.4789, green: 0.0, blue: 0.4788, alpha: 1.0 )
    var highlighted    = UIColor.whiteColor()
    var onArr:[Bool] = []
    var buttonArray:[UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.width = self.view.frame.size.width
        self.height = self.view.frame.size.height
        setupButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createAndAddButton(index:Int, row:Int) ->UIButton{
        let button = UIButton(type: .System)
        
        
        let w = (width-(10.0*(CGFloat(n)+1.0)))/CGFloat(n)
        let h = CGFloat(80)
        let x = 10 + (10.0*(CGFloat(index%n)))+CGFloat((CGFloat(index % n)+1.0)*w) - w
        let y = CGFloat((row+1)*90)
     print("index:\(index) \(row)\t \(x)\t \(y)")
        
        button.frame = CGRectMake(x, y, w, h)
        button.backgroundColor = self.nonhighlighted
        button.accessibilityLabel = "\(index)"
        button.tag = index
        button.addTarget(self, action: #selector(ViewController.buttonTouched(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        return button
    }

    func setupButtons() {
        for i in 0..<n*n {
//            print("i:\(i) n=\(n), i%n = \(i%n), row=\(trunc(Double(i/n)))")
            self.buttonArray.append(createAndAddButton(i, row: Int(trunc(Double(i/n)))))
            onArr.append(false)
        }
    }
   
    func toggleButton(index:Int) {
        print("toggle \(index)")
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
        for b in self.buttonArray {
            if b.backgroundColor != UIColor.whiteColor(){
                return
            }
        }
        
        //They won
        let alert = UIAlertController(title: "Congratulations",
                                      message: "You've won this round!",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Close",
            style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

