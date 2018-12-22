//
//  CustomViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 18/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit

protocol CommunicationChannel : class {
    func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
}

class CustomViewController: UIViewController, CommunicationChannel {
    
    weak var communicationChannel: CommunicationChannel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedAmber" {
            let  dvc = segue.destination as! MaybeCollectionViewController
            communicationChannel = dvc
        } else if segue.identifier == "EmbedGreen" {
            let dvc = segue.destination as! YesCollectionViewController
            dvc.delegate = self
        } else if segue.identifier == "EmbedRed" {
            let  dvc = segue.destination as! NoCollectionViewController
             dvc.delegate = self
            //print(dvc.delegate!)
            //communicationChannel = dvc
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
     {
        communicationChannel?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
    }
    

}
