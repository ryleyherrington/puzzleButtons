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
    
    //IBOutlets
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.width  = self.view.frame.size.width 
        self.height = self.containerView.frame.size.height
        
        setupButtons()
        setupSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSlider(){
        self.slider.minimumValue = 3.0
        self.slider.maximumValue = 5.0
        self.slider.minimumTrackTintColor = UIColor ( red: 0.0, green: 0.6961, blue: 0.6382, alpha: 1.0 )
        self.slider.maximumTrackTintColor = UIColor ( red: 0.0, green: 0.6961, blue: 0.6382, alpha: 1.0 )
        self.slider.setValue(3.0, animated: true)
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        self.numLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func startGame(sender: AnyObject) {
        self.n = Int(self.slider.value)
        removeAllButtons()
        setupButtons()
    }
    
    func removeAllButtons() {
        for b in self.buttonArray {
            b.removeFromSuperview()
        }
        
        self.buttonArray.removeAll()
        self.onArr.removeAll()
    }
    
    func createAndAddButton(index:Int, row:Int, w:CGFloat, h:CGFloat) ->UIButton{
        let button = UIButton(type: .System)
        
        let x = (10.0*(CGFloat(index%n)))+CGFloat((CGFloat(index % n)+1.0)*w) - w
        let y = CGFloat((row)*90)
        
        button.frame = CGRectMake(x, y, w, h)
        button.backgroundColor = self.nonhighlighted
        button.accessibilityLabel = "\(index)"
        button.tag = index
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

