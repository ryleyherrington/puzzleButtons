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
        let x = w*CGFloat(index%n)+CGFloat((index%n)*10)+10.0
        let y = CGFloat((row+1)*90)
        
        button.frame = CGRectMake(x, y, w, h)
        button.backgroundColor = self.nonhighlighted
        button.accessibilityLabel = "\(index)"
        button.tag = index
        button.addTarget(self, action: #selector(ViewController.buttonTouched(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        return button
    }

    func setupButtons() {
        for r in 0..<n {
            for c in 0..<n {
                self.buttonArray.append(createAndAddButton(r+c, row: r))
                onArr.append(false)
            }
        }
    }
   
    func toggleButton(index:Int) {
        print("toggle \(index)")
    }
    
    func buttonTouched(sender:UIButton){
        if sender.backgroundColor == self.nonhighlighted {
            sender.backgroundColor = self.highlighted
        } else {
            sender.backgroundColor = self.nonhighlighted
        }
        
        checkWin()
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

