//
//  ViewController.swift
//  MemeMe
//
//  Created by Nathaniel Warner on 3/9/18.
//  Copyright © 2018 Nathaniel Warner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeTextTop: UITextField!
    @IBOutlet weak var memeTextBottom: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let defaultMemeTopText = "MEME TOP"
    let defaultMemeBottomText = "MEME BOTTOM"
    
    let memeTextAttributes: [String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -1.5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeTextTop.text = defaultMemeTopText
        memeTextTop.delegate = self
        memeTextTop.defaultTextAttributes = memeTextAttributes
        memeTextTop.textAlignment = NSTextAlignment.center
        
        memeTextBottom.text = defaultMemeBottomText
        memeTextBottom.delegate = self
        memeTextBottom.defaultTextAttributes = memeTextAttributes
        memeTextBottom.textAlignment = NSTextAlignment.center
    }
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if memeImageView.image == nil {
            shareButton.isEnabled = false
        }
        subscribeToKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickImage(source: .photoLibrary)
    }
    
    @IBAction func getImageFromCamera(_ sender: Any) {
        pickImage(source: .camera)
    }
    func pickImage(source: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            memeImageView.image = image
            print("share about to enable")
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == memeTextTop {
            if textField.text == defaultMemeTopText {
                textField.text = ""
            }
        } else if textField == memeTextBottom {
            if textField.text == defaultMemeBottomText {
                textField.text = ""
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if memeTextBottom.isEditing {
            view.frame.origin.y = -1 * getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: memeTextTop.text!, bottomText: memeTextBottom.text!, originalImage: memeImageView.image!, memeImage: memedImage)
    }
    func generateMeme() -> UIImage {
        navBar.isHidden = true
        toolbar.isHidden = true
        memeTextTop.resignFirstResponder()
        memeTextBottom.resignFirstResponder()
        if memeTextTop.text == defaultMemeTopText {
            memeTextTop.isHidden = true
        }
        if memeTextBottom.text == defaultMemeBottomText {
            memeTextBottom.isHidden = true
        }
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolbar.isHidden = false
        memeTextTop.isHidden = false
        memeTextBottom.isHidden = false
        
        return memedImage
    }
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = generateMeme()
        let shareActivityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        shareActivityController.completionWithItemsHandler = {(actityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            print(completed)
            if completed {
                self.save(memedImage: memeImage)
            }
        }
        self.present(shareActivityController, animated: true, completion: nil)
    }
    @IBAction func cancelMeme(_ sender: Any) {
        memeTextTop.text = defaultMemeTopText
        memeTextBottom.text = defaultMemeBottomText
        memeImageView.image = nil
        shareButton.isEnabled = false
    }
    
}
struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memeImage: UIImage
}

