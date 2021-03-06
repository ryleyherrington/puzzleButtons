//
//  WinningViewController.swift
//  Puzzle Buttons
//
//  Created by Ryley Herrington on 4/21/16.
//  Copyright © 2016 Herrington. All rights reserved.
//

import UIKit

class WinningViewController: UIViewController {

    var inset:CGFloat = 19.0
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var screenshot: UIImageView!
    @IBOutlet weak var overlay: ConfettiView!
    
    var shareText:String = ""
    var moves:String = ""
    var movesList:String = ""
    var titleString:String = "Congratulations"
    var backgroundImg:UIImage = UIImage()
    var didWin:Bool = true
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImage()
        self.movesLabel.text = moves
        self.screenshot.image = backgroundImg
        self.titleLabel.text = titleString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.overlay.frame = self.view.frame
        self.mainView.layer.cornerRadius = 8
        
        UIView.animate(withDuration: 0.6, delay: 0.0,
                       usingSpringWithDamping: 0.5, //Damping ratios less than 1 will oscillate more
                       initialSpringVelocity: 0,
                       options: .curveEaseIn, animations: {
                        
            self.mainView.frame = CGRect(x: self.mainView.frame.origin.x,
                                         y: self.view.frame.size.height/2-self.mainView.frame.size.height/2,
                                         width: self.mainView.frame.size.width,
                                         height: 158)
            self.overlay.alpha = 0.3
        })
        
        if self.didWin == true{
            overlay.startAnimating()
        }else {
            overlay.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupBackgroundImage(){
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: #selector(WinningViewController.tappedOverlay))
        
        let upSwipeRec = UISwipeGestureRecognizer()
        upSwipeRec.direction = .up
        upSwipeRec.addTarget(self, action: #selector(WinningViewController.upSwipe))
        
        let downSwipeRec = UISwipeGestureRecognizer()
        downSwipeRec.direction = .down
        downSwipeRec.addTarget(self, action: #selector(WinningViewController.downSwipe))
        
        
        overlay.addGestureRecognizer(tapRec)
        overlay.addGestureRecognizer(upSwipeRec)
        overlay.addGestureRecognizer(downSwipeRec)
        overlay.isUserInteractionEnabled = true
        
        overlay.alpha = 0.0
    }
    
    func dismiss(direction: UISwipeGestureRecognizerDirection){
        UIView.animate(withDuration: 0.2, animations: {
            
            if direction == .down {
                self.mainView.frame = CGRect(x: self.inset, y: self.view.frame.size.height, width: self.view.frame.size.width-self.inset, height: 158)
            } else  {
                self.mainView.frame = CGRect(x: self.inset, y: -158, width: self.view.frame.size.width, height: 158)
            }
            self.overlay.alpha = 0.0
            self.overlay.stopAnimating()
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
    
    
    @IBAction func shareButtonTapped(_ sender: AnyObject) {
        if shareText == "" {
            shareText = "Just finished this puzzle! #puzzleButtons"
        }
        
        let objectsToShare = [shareText]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        
        self.present(activityVC, animated: true, completion:nil)
            //TODO:RYLEY this is not the right way to do this. PLS FIX
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
//                self.dismiss(direction: .down)
//            }
            
//        })
        
    }
    
    @IBAction func dismissVC(_ sender: AnyObject) {
        dismiss(direction: .down)
    }
}
