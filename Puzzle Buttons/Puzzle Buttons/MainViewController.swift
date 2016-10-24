//
//  MainViewController.swift
//  Puzzle Buttons
//
//  Created by Ryley Herrington on 4/9/16.
//  Copyright © 2016 Herrington. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, CustomGameDelegate {
    
    func startCustomGame(sender: CheatCodeViewController, game:String) {
        self.gameString = game
    }

    //View Vars
    var n:Int = 3 //number of rows / columns
    var width:CGFloat = 0
    var height:CGFloat = 0
    
    //Colors
    var nonhighlighted = UIColor ( red: 0.4789, green: 0.0, blue: 0.4788, alpha: 1.0 )
    var highlighted    = UIColor.white
    
    //Game Vars
    var onArr:[Bool] = []
    var buttonArray:[UIButton] = []
    var movesStack:[Int] = []
    var shareGame:[Int]  = []
    var gameString = ""
    var random:Bool = false
    
    //IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width  = self.view.frame.size.width
        height = self.containerView.frame.size.height
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        if buttonArray.count <= 0 {
            setupButtons()
        }
        
        if gameString != ""{
            loadGame(gameString)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        gameString = ""
    }
   
    func loadGame(_ gameNumber:String){
        var game = gameNumber
        
        if game.characters.first == "3" {
            seg.selectedSegmentIndex = 0
            n = 3

            resetHelper()
        } else {
            seg.selectedSegmentIndex = 1
            n = 4
            resetHelper()
        }
        
        let r = String(game.characters.dropFirst(1))
        for c in r.characters{
            let intVal = Int("\(c)")
            touchButtonWithIndex(intVal!)
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //IBActions
    @IBAction func indexChanged(_ sender:UISegmentedControl) {
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
        random = false
    }
    
    @IBAction func resetGame(_ sender: AnyObject) {
        resetHelper()
    }
    
    //random button
    @IBAction func startGame(_ sender: AnyObject) {
        removeAllButtons()
        setupButtons()
        let upper = UInt32((n*n)-1)
        for _ in 0...n*n {
            let b = buttonArray[Int(arc4random_uniform(upper))]
            b.sendActions(for: .touchUpInside)
        }
        shareGame = movesStack
        movesStack.removeAll()
        random = true
    }
    
    @IBAction func shareTapped(_ sender: AnyObject) {
        share(false)
    }
    
    @IBAction func cheatCodesButtonTapped(_ sender: AnyObject) {
        cheatCode()
    }
    
    @IBAction func undo(_ sender: AnyObject) {
        if self.movesStack.last != nil {
            let b = buttonArray[self.movesStack.last!]
            self.movesStack.removeLast()
            b.sendActions(for: .touchUpInside)
            self.movesStack.removeLast()
        }
    }
   
    func touchButtonWithIndex(_ int:Int) {
        let b = buttonArray[int]
        b.sendActions(for: .touchUpInside)
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
        let button = UIButton(type: .system)
       
        let x = 5+(10.0*(CGFloat(index%n)))+CGFloat((CGFloat(index % n)+1.0)*w) - w
        let y = CGFloat(row)*(h + 5)
        
        button.frame = CGRect(x: x, y: y, width: w, height: h)
        button.backgroundColor = self.nonhighlighted
        button.accessibilityLabel = "\(index)"
        button.tag = index
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(MainViewController.buttonTouched(_:)), for: UIControlEvents.touchUpInside)
        
        self.containerView.addSubview(button)
        return button
    }

    func setupButtons() {
        let w = (width-(10.0*(CGFloat(n)+1.0)))/CGFloat(n)
        let h = self.containerView.frame.size.height/(CGFloat(n)+1.3)
        
        
        for i in 0..<n*n {
//            print("i:\(i) n=\(n), i%n = \(i%n), row=\(trunc(Double(i/n)))")
            self.buttonArray.append(createAndAddButton(index:i, row: Int(trunc(Double(i/n))), w:w, h:h))
            onArr.append(false)
        }
    }
   
    func toggleButton(_ index:Int) {
        let button = buttonArray[index]
        let origFrame = button.frame
        
        UIView.animate(withDuration: 0.2, animations: {
            button.frame = CGRect(x: origFrame.origin.x, y: origFrame.origin.y, width: 0, height: origFrame.size.height)
        }, completion: { (_) in
            if button.backgroundColor == self.nonhighlighted {
                button.backgroundColor = self.highlighted
                self.onArr[index] = true
            } else {
                button.backgroundColor = self.nonhighlighted
                self.onArr[index] = false
            }
            
            UIView.animate(withDuration: 0.3, animations: { 
                button.frame = origFrame
            })
            
        }) 
    }
    
    func buttonTouched(_ sender:UIButton){
        self.movesStack.append(sender.tag)
        
        toggleButton(sender.tag)
        if isLeftEdge(sender.tag) {
            changeLeft(sender.tag)
        } else if isRightEdge(sender.tag){
            changeRight(sender.tag)
        } else {
            changeMiddle(sender.tag)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.checkWin()
        }
    }
    
    func isLeftEdge(_ index:Int) -> Bool {
        if (index%n == 0) {
            return true
        }
        return false
    }
    
    func changeLeft(_ index:Int) {
        if index - n >= 0 {
            toggleButton(index-n)
        }
        if index + n < n*n {
            toggleButton(index+n)
        }
        toggleButton(index+1)
    }
   
    func isRightEdge(_ index:Int) -> Bool {
        if (index%n == n-1) {
            return true
        }
        return false
    }
    
    func changeRight(_ index:Int) {
        if index - n >= 0 {
            toggleButton(index-n)
        }
        if index + n < n*n {
            toggleButton(index+n)
        }
        toggleButton(index-1)
    }
   
    func changeMiddle(_ index:Int) {
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
    
    func share(_ didWin:Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let winningVC = storyboard.instantiateViewController(withIdentifier: "WinningViewController") as! WinningViewController
        
        var beginGame = "\(self.shareGame)"
        beginGame = beginGame.replacingOccurrences(of: "[", with: "")
        beginGame = beginGame.replacingOccurrences(of: "]", with: "")
        beginGame = beginGame.replacingOccurrences(of: ",", with: "")
        beginGame = beginGame.replacingOccurrences(of: " ", with: "")
        
        winningVC.didWin = didWin
       
        if didWin {
            winningVC.titleString = "Congratulations"
            
            if shareGame.count < 1 && self.movesStack.count > 1{
            winningVC.shareText = "Hey, I just won my \(n)x\(n)puzzlebuttons game in \(self.movesStack.count) moves!"
            } else {
                winningVC.shareText = "Hey, I just won game #\(beginGame) in #puzzlebuttons!"
            }
        } else if beginGame == ""{
            winningVC.titleString = "Share this game!"
            winningVC.shareText = "Checkout Puzzle Buttons on the app store."
        } else {
            winningVC.titleString = "Share this game!"
            winningVC.shareText = beginGame
        }
       
        //TODO:FIX THIS RYLEY THIS IS COMPLETE SHIT
        
        if beginGame != "" && self.movesStack.count != 0 {
                winningVC.moves = "Game #\(beginGame)"
        } else if self.movesStack.count > 0 {
                winningVC.moves = "\(self.movesStack.count) moves!"
        } else {
            winningVC.moves = "Checkout Puzzle Buttons on the app store."
        }
        
            
        //get screenshot
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        winningVC.backgroundImg = screenshot!

        self.present(winningVC, animated: false, completion: nil)
    }
   
    func cheatCode() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cheatVC = storyboard.instantiateViewController(withIdentifier: "CheatCodeViewController") as! CheatCodeViewController
        
        //get screenshot
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        cheatVC.backgroundImg = screenshot!
        cheatVC.delegate = self
        
        self.present(cheatVC, animated: false, completion: nil)
    }

}

