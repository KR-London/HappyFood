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
import Darwin

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  //  var haveIjustComeFrom
    
    @IBAction func takeAnotherPhoto(_ sender: UIButton) {
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraRollButton: UIButton!
    
    @IBAction func pickFromCameraRoll(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
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
    
    @IBAction func deletePic(_ sender: UIButton) {
        cameraImage.image = nil
        
        cameraRollButton.isHidden = false
        cameraButton.isHidden = false
        deleteButton.isHidden = true
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBOutlet weak var cameraImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.isHidden = true
   
  
        imagePicker.delegate = self
       // imagePicker.sourceType = .camera
        //imagePicker.allowsEditing = true
        
        //present(imagePicker, animated: true, completion: nil)
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
        cameraButton.isHidden = true
        cameraRollButton.isHidden = true
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let userPickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        {
            let maskingImage = UIImage(named: "MASK.png")
            
            var pic = userPickedImage.fixOrientation()
           pic = pic!.resizeImage(targetSize: CGSize(width: 500, height:300))
            
           // cameraImage.image = pic
           cameraImage.image = maskImage(image: pic!, mask: maskingImage!)
            //  cameraImage.transform.rotated(by: CGFloat(Double.pi/2.0))
            //  cameraImage.image = cameraImage
            //  cameraImage.
            //  cameraImage.image = userPickedImage
            
            deleteButton.isHidden = false
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
    
@objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        cameraButton.isHidden = false
        deleteButton.isHidden = true
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
           // cameraImage.image = nil
            //deleteButton.isHidden = true
           // cameraButton.titleLabel!.text = "Hello"
          
            if let newPic = cameraImage.image{
                let seconds = String(Date.timeIntervalSinceReferenceDate).filter{$0 != "."}
                appsAndBiscuits(imageName: seconds, image: newPic, rating:  2)
            }
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
        
        let image2 = image.resizeImage(targetSize: CGSize(width: 500, height: 300))
        
        let data = UIImage.pngData(image2)
        
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
            foodsTriedThisWeek =  [( imagePath, IndexPath.init(item: 99, section: 99), "fromCamera")] + (foodsTriedThisWeek ?? [])
        }
        
        cameraImage.image = nil
        cameraRollButton.isHidden = false
        
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

extension UIImage {
    
    func fixOrientation() -> UIImage? {
        
        if (imageOrientation == .up) { return self }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0.0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0.0, y: size.height)
            transform = transform.rotated(by: -.pi / 2.0)
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        default:
            break
        }
        
        guard let cgImg = cgImage else { return nil }
        
        if let context = CGContext(data: nil,
                                   width: Int(size.width), height: Int(size.height),
                                   bitsPerComponent: cgImg.bitsPerComponent,
                                   bytesPerRow: 0, space: cgImg.colorSpace!,
                                   bitmapInfo: cgImg.bitmapInfo.rawValue) {
            
            context.concatenate(transform)
            
            if imageOrientation == .left || imageOrientation == .leftMirrored ||
                imageOrientation == .right || imageOrientation == .rightMirrored {
                context.draw(cgImg, in: CGRect(x: 0.0, y: 0.0, width: size.height, height: size.width))
            } else {
                context.draw(cgImg, in: CGRect(x: 0.0 , y: 0.0, width: size.width, height: size.height))
            }
            
            if let contextImage = context.makeImage() {
                return UIImage(cgImage: contextImage)
            }
            
        }
        
        return nil
    }
    
}


