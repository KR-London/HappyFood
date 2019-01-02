//
//  RibbonsOnboardingViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 27/12/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit

class RibbonsOnboardingViewController: UIViewController {

    
    @IBAction func segueTrigger(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "trafficLightStoryboard") as! CustomViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
