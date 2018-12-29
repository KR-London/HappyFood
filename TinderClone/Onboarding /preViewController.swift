//
//  preViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 23/12/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit

class preViewController: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
           //  self.performSegue(withIdentifier: "goToMainUI", sender: nil)
            // Do any additional setup after loading the view, typically from a nib.
//            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.performSegue(withIdentifier: "goToMainUI", sender: self)
            }
    
    }
        
        @objc func timeToMoveOn() {
            self.performSegue(withIdentifier: "goToMainUI", sender: self)
        }

}
