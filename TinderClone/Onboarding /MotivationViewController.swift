//
//  MotivationViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 27/12/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit

class MotivationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var motivationInputField: UITextField!
    
    func textFieldShouldReturn(_ motivationInputField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func submitMotivation(_ sender: UIButton) {
        
    
        
    }
    //    @IBAction func transitionToNextOnboardingStep(_ sender: Any) {//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//        guard let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "explainRibbons") as? RibbonsOnboardingViewController
//            else
//        {
//            print("Couldn't find view controller")
//            return
//        }
//
//        navigationController?.pushViewController(destinationVC, animated: true)
//    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motivationInputField.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.performSegue(withIdentifier: "goToRibbonsOnboarding", sender: self)
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
