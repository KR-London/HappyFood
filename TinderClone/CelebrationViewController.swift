//
//  CelebrationViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 09/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class CelebrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.performSegue(withIdentifier: "toTrafficLightStoryboard", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
