//
//  CheatCodeViewController.swift
//  Puzzle Buttons
//
//  Created by Ryley Herrington on 4/21/16.
//  Copyright © 2016 Herrington. All rights reserved.
//

import UIKit

protocol CustomGameDelegate: class {
    func startCustomGame(sender: CheatCodeViewController, game:String)
}

class CheatCodeViewController: UIViewController, UITextViewDelegate{
    
    var inset:CGFloat = 19.0
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var screenshot: UIImageView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var gameInputField: UITextField!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    var titleString:String = "Game Number:"
    var backgroundImg:UIImage = UIImage()
    
    weak var delegate:CustomGameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImage()
        self.screenshot.image = backgroundImg
        self.titleLabel.text = titleString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.overlay.frame = self.view.frame
        
        self.bottomSpaceConstraint.constant = -358
        UIView.animate(withDuration: 0.6, delay: 0.0,
                       usingSpringWithDamping: 0.5, //Damping ratios less than 1 will oscillate more
            initialSpringVelocity: 0,
            options: .curveEaseIn, animations: {
//                self.mainView.frame = CGRect(x: self.mainView.frame.origin.x,
//                                             y: self.view.frame.size.height/2-self.mainView.frame.size.height/2,
//                                             width: self.mainView.frame.size.width,
  //                                           height: 158)
                self.view.layoutIfNeeded()
                self.overlay.alpha = 0.3
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    
    func setupBackgroundImage(){
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: #selector(CheatCodeViewController.tappedOverlay))
        
        let upSwipeRec = UISwipeGestureRecognizer()
        upSwipeRec.direction = .up
        upSwipeRec.addTarget(self, action: #selector(CheatCodeViewController.upSwipe))
        
        let downSwipeRec = UISwipeGestureRecognizer()
        downSwipeRec.direction = .down
        downSwipeRec.addTarget(self, action: #selector(CheatCodeViewController.downSwipe))
        
        
        overlay.addGestureRecognizer(tapRec)
        overlay.addGestureRecognizer(upSwipeRec)
        overlay.addGestureRecognizer(downSwipeRec)
        overlay.isUserInteractionEnabled = true
        
        overlay.alpha = 0.0
    }
    
    func dismiss(direction: UISwipeGestureRecognizerDirection){
        UIView.animate(withDuration: 0.2, animations: {
            if direction == .down {
                self.mainView.frame = CGRect(x: self.inset, y: self.view.frame.size.height, width: self.view.frame.size.width-self.inset*2, height: 158)
            } else  {
                self.mainView.frame = CGRect(x: self.inset, y: -158, width: self.view.frame.size.width-self.inset*2, height: 158)
            }
            self.overlay.alpha = 0.0
            }, completion: { (_) in
                self.dismiss(animated: false, completion: nil)
        })
    }
    
    func tappedOverlay(){
        dismiss(direction: .down)
    }
    
    func upSwipe(){
        dismiss(direction: .up)
    }
    
    func downSwipe(){
        dismiss(direction: .down)
    }
    
    @IBAction func cheatCodeChanged(_ sender: UITextField) {
        self.gameInputField.text = self.gameInputField.text?.trimmingCharacters(in: NSCharacterSet(charactersIn: "0123456789").inverted)
    }
    
    @IBAction func dismissVC(_ sender: AnyObject) {
        if (gameInputField.text?.characters.count)! > 0{
            self.delegate?.startCustomGame(sender: self, game: gameInputField.text!)
        }
        
        dismiss(direction: .down)
        
    }
}
