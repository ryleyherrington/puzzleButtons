//
//  WinningViewController.swift
//  Puzzle Buttons
//
//  Created by Ryley Herrington on 4/21/16.
//  Copyright © 2016 Herrington. All rights reserved.
//

import UIKit

class WinningViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var screenshot: UIImageView!
    @IBOutlet weak var movesListLabel: UILabel!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var topToBottomC: NSLayoutConstraint!
    
    var shareText:String = ""
    var moves:String = ""
    var movesList:String = ""
    
    var backgroundImg:UIImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImage()
        self.movesLabel.text = moves
        self.movesListLabel.text = movesList
        self.screenshot.image = backgroundImg
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3) {
        self.overlay.frame = self.view.frame
            self.mainView.frame = CGRectMake(0, self.view.frame.size.height-96, self.view.frame.size.width, 96)
            self.overlay.alpha = 0.3
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupBackgroundImage(){
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: #selector(WinningViewController.tappedOverlay))
        
        overlay.addGestureRecognizer(tapRec)
        overlay.userInteractionEnabled = true
        
        overlay.alpha = 0.0
    }
    
    func dismiss (){
        UIView.animateWithDuration(0.3, animations: {
            self.mainView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 96)
            self.overlay.alpha = 0.0
        }) { (_) in
            self.dismissViewControllerAnimated(false) {
                print("dismissed Share")
            }
        }
    }
    
    func tappedOverlay(){
        print("tapped")
        dismiss()
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        if shareText == "" {
            shareText = "Just finished this puzzle! #puzzleButtons"
        }
        
        let objectsToShare = [shareText]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissVC(sender: AnyObject) {
        dismiss()
    }
}
