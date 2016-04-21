//
//  ShareViewController.swift
//  Puzzle Buttons
//
//  Created by Ryley Herrington on 4/21/16.
//  Copyright © 2016 Herrington. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var numMovesLbl: UILabel!
   
    var shareText:String = ""
    var moves:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numMovesLbl.text = moves
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismiss (){
//        UIView.animateWithDuration(1.0, animations: {
//            self.screenshot.hidden = true
//            self.overlay.hidden = true
//            self.topToBottomC.constant = 0
//        }) { (_) in
            self.dismissViewControllerAnimated(true) {
                print("dismissed Share")
            }
      //  }
    }
    
    @IBAction func dissmissButtonTouched(sender: AnyObject) {
        dismiss()
    }

    @IBAction func shareButtonTouched(sender: AnyObject) {
        if shareText == "" {
            shareText = "Just finished this puzzle! #puzzleButtons"
        }
        
        let objectsToShare = [shareText]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }

}
