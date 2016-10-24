//
//  BorderedButton.swift
//  Puzzle Buttons
//
//  Created by Ryley Herrington on 10/11/16.
//  Copyright © 2016 Herrington. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = tintColor.cgColor
        layer.cornerRadius = 5.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(tintColor, for: .normal)
        setTitleColor(UIColor.white, for: .highlighted)
    }
 
}
