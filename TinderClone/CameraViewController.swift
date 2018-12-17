//
//  CameraViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 27/11/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory,
                                in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    @IBOutlet weak var cameraImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        //cameraImage = imagePicker
        

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let userPickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        {
            cameraImage.image = userPickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func saveItems(){
        do{ try context.save() }
        catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /// Put in gesture handler code
    /// make sure the image is trimmed to be a square
    
    
    
                                                                                //    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
                                                                                //        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
                                                                                //            print("Swipe Right")
                                                                                //            let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                                                                //
                                                                                //            guard let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "trafficLightStoryboard") as? CustomViewController
                                                                                //                else
                                                                                //            {
                                                                                //                print("Couldn't find view controller")
                                                                                //                return
                                                                                //            }
                                                                                //
                                                                                //            navigationController?.pushViewController(destinationVC, animated: true)
                                                                                //
                                                                                //        }
                                                                                //        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
                                                                                //            print("Swipe Left")
                                                                                //
                                                                                //            foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 2
                                                                                //            updatePicture()
                                                                                //        }
                                                                                //        else if gesture.direction == UISwipeGestureRecognizer.Direction.up {
                                                                                //            print("Swipe Up")
                                                                                //
                                                                                //
                                                                                //            foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 1
                                                                                //            updatePicture()
                                                                                //        }
                                                                                //        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
                                                                                //            print("Swipe Down")
                                                                                //
                                                                                //            foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 3
                                                                                //            updatePicture()
                                                                                //            //self.storyboard
                                                                                //
                                                                                //
                                                                                //            
                                                                                //
                                                                                //            //onButtonTapped()
                                                                                //            // performSegue(withIdentifier: goToData, sender: self)
                                                                                //        }
                                                                                //    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
