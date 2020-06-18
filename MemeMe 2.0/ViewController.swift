//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Abdulkrum Alatubu on 20/09/1441 AH.
//  Copyright © 1441 Abdulkrum Alatubu. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var Nav: UINavigationBar!
    @IBOutlet weak var tool: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    @IBOutlet weak var cameraItem: UIBarButtonItem!
    @IBOutlet weak var TheImage: UIImageView!
    @IBOutlet weak var Share: UIBarButtonItem!
    
   
    var ToptextHasDefulatValue = true
    var BottomtextHasDefulatValue = true
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
              NSAttributedString.Key.strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
              NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
              NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
              NSAttributedString.Key.strokeWidth:  -2
          ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Share.isEnabled = false
        // add tag to TextFields
        topTextField.tag = 0
        BottomTextField.tag = 1
      
        
        configureMemeTextField(textField: topTextField, text: "TOP")
        configureMemeTextField(textField: BottomTextField, text: "BOTTOM")
        
        
        //The Camera button is disabled when app is run on devices without a camera, such as the simulator.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            cameraItem.isEnabled = true
        }
        else {

             cameraItem.isEnabled = false
        }
        
    }
    
    
    func configureMemeTextField(textField: UITextField, text: String) {
          textField.text = text
          textField.delegate = self
          textField.defaultTextAttributes = memeTextAttributes
          textField.textAlignment = .center
      }
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.tool.isHidden = true
        self.Nav.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.tool.isHidden = false
        self.Nav.isHidden = false
        return memedImage
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            //remove the Notification
            unsubscribeFromKeyboardNotifications()
            if self.ToptextHasDefulatValue {
                //clear the defulat textField
                topTextField.text = ""
            }
   
        }else{
            if self.BottomtextHasDefulatValue {
                //clear the defulat textField
                BottomTextField.text = ""
            }
            //add Observer for keyboardWillShow and keyboardWillHide
            subscribeToKeyboardNotifications()
        }
  
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // check if the user change the defulat text
        if textField.tag == 0 {
            self.ToptextHasDefulatValue = false
        }else{
            self.BottomtextHasDefulatValue = false
        }

        return true;
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func save(itemMemedImage: UIImage){
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.BottomTextField.text!, originalImage: self.TheImage.image!, memedImage: itemMemedImage)
           // Add it to the memes array in the Application Delegate
           let object = UIApplication.shared.delegate
           let appDelegate = object as! AppDelegate
           appDelegate.memes.append(meme)
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)

    }
    @IBAction func share(_ sender: Any) {
        let itemMemed = generateMemedImage()
       
        let ac = UIActivityViewController(activityItems: [itemMemed as Any], applicationActivities: nil)
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
            if completed {
                
                self.save(itemMemedImage: itemMemed)
                self.dismiss(animated: true, completion: nil)
            }else{
                print("the user doesn't select anything")
            }
        }
        
        present(ac, animated: true)
    }
   //pick a image from photoLibrary
    @IBAction func pick(_ sender: Any) {
      pickAnImage(sourceType: .photoLibrary)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //pick a image from camera
    @IBAction func camera(_ sender: Any) {
        pickAnImage(sourceType: .camera)
    }
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
         let imagePickerController = UIImagePickerController()
         imagePickerController.delegate = self
         imagePickerController.sourceType = sourceType
         present(imagePickerController, animated: true, completion: nil)
     }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            TheImage.contentMode = .scaleAspectFit
            TheImage.image = pickedImage
        }
        // check if the user add image in UIimageView
        if TheImage.image != nil {
            Share.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
}






