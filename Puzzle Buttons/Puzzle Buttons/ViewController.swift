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
    var highlighted    = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
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
        // Dispose of any resources that can be recreated.
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
        button.titleLabel?.text = "\(index)"
        button.titleLabel?.textColor = UIColor.whiteColor()
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
    
    func buttonTouched(sender:UIButton){
        print("\(sender.tag): \(onArr[sender.tag]) ---- ")
        if sender.backgroundColor == self.nonhighlighted {
            sender.backgroundColor = self.highlighted
            onArr[sender.tag] = true
        } else {
            sender.backgroundColor = self.nonhighlighted
            onArr[sender.tag] = false
        }
        print("\(sender.tag): \(onArr[sender.tag])\n")
        if checkWin() == true {
            let alertController = UIAlertController(title: "Congratulations!", message: "You won this round.", preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true){
                print("Won")
            }
        }
    }

    func checkWin() -> Bool{
        for i in onArr {
            if i == false{
                return false
            }
        }
        return true
    }
}

