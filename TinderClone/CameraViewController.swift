//
//  CameraViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 27/11/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func takeAnotherPhoto(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func segueTrigger(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "trafficLightStoryboard") as! CustomViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
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
        
        ///imagePickerController(imagePicker, didFinishPickingMediaWithInfo: <#T##[UIImagePickerController.InfoKey : Any]#>)
        
        /// define swipe directions
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let userPickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        {
            let maskingImage = UIImage(named: "MASK.png")
            cameraImage.image = maskImage(image: userPickedImage, mask: maskingImage!)
           // cameraImage.image = userPickedImage
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
    
//    let fileDirectory  : URL =  {
//        return FileManager.default
//    }
//    func saveImageToDocuments(image: UIImage, fileNameWithExtension: String){
//        let imagePath =  FileManager.default.urls(for: .documentDirectory,
//                                        in: .userDomainMask).first?.appendingPathComponent("\(fileNameWithExtension)")
//        let imageData = UIImage.pngData(image)
//        try! imageData()?.write(to: imagePath!)
//
//         if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//                let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
//                menuItem.image_file_name = "dopey.png"
//                menuItem.name = "dopey"
//                menuItem.rating = Int16(2)
//                saveItems()
//        }
//        testIamge.image = UIImage(named: "dopey.png" )
//
//    }

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
    
    
    
@objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            cameraImage.image = nil
        
         }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
             if let newPic = cameraImage.image{
            let seconds = String(Date.timeIntervalSinceReferenceDate).filter{$0 != "."}
            appsAndBiscuits(imageName: seconds, image: newPic, rating:  2)
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.up {
             if let newPic = cameraImage.image{
            let seconds = String(Date.timeIntervalSinceReferenceDate).filter{$0 != "."}
            appsAndBiscuits(imageName: seconds, image: newPic, rating:  1)
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            
            if let newPic = cameraImage.image{
            let seconds = String(Date.timeIntervalSinceReferenceDate).filter{$0 != "."}
            appsAndBiscuits(imageName: seconds, image: newPic, rating:  3)
            }
        }
    }

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
    
    
    func appsAndBiscuits(imageName: String, image: UIImage, rating: Int){
        
        /// create an instance of filemanager
        let fileManager = FileManager.default
        
        /// get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        /// get the png data for this image
        
        let data = UIImage.pngData(image)
        
        fileManager.createFile(atPath: imagePath as String, contents: data(), attributes: nil)
        
        
        //cameraImage.image = UIImage(contentsOfFile: imagePath)
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
            menuItem.image_file_name = imagePath
            menuItem.name = imageName
            menuItem.rating = Int16(rating)
            saveItems()
        }
        
        /// if they indicate a definite prefernce - take this as a sign you liked it. Maybe as a sign you're just adding to database.
        
        if rating == 1 || rating == 3
        {
            foodsTriedThisWeek =  [( imageName, IndexPath.init(item: 99, section: 99), "fromCamera")] + (foodsTriedThisWeek ?? [])
        }
        
        cameraImage.image = nil
    }
    
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: maskReference!.width,
                                height: maskReference!.height,
                                bitsPerComponent: maskReference!.bitsPerComponent,
                                bitsPerPixel: maskReference!.bitsPerPixel,
                                bytesPerRow: maskReference!.bytesPerRow,
                                provider: maskReference!.dataProvider!, decode: nil, shouldInterpolate: true)
        
        let maskedReference = imageReference!.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage:maskedReference!)
        
        return maskedImage
    }

}
