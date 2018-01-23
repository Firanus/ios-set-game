//
//  ViewController.swift
//  Set
//
//  Created by Ivan Tchernev on 23/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var uiCards: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        toggleSelection(of: sender)
        
        let textColor = sender.titleColor(for: UIControlState.normal)!
        print(textColor)
        print(sender.title(for: UIControlState.normal) ?? "Empty")
        print(sender.title(for: UIControlState.normal)?.count ?? 0)
    }
    
    func toggleSelection(of button: UIButton){
        if button.layer.borderWidth < 3.0 {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.blue.cgColor
        } else {
            button.layer.borderWidth = 0.0
            button.layer.borderColor = UIColor.white.cgColor
        }
    }
}
