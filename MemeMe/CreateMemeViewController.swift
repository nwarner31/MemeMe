//
//  CreateMemeViewController.swift
//  MemeMe
//
//  Created by Nathaniel Warner on 3/9/18.
//  Copyright © 2018 Nathaniel Warner. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: - Properties
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
    // MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(textField: memeTextTop, defaultText: defaultMemeTopText)
        setupTextField(textField: memeTextBottom, defaultText: defaultMemeBottomText)
    }
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Check to see if there is an image selected and if not disable the share button.
        if memeImageView.image == nil {
            shareButton.isEnabled = false
        }
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    // MARK: - Image picker functions
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
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Text field functions
    func setupTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if [defaultMemeTopText, defaultMemeBottomText].contains(textField.text!) {
            textField.text = ""
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
    // MARK: - Meme functions
    func generateMeme() -> UIImage {
        // Sets up the UI to create the meme
        let topTextChanged = memeTextTop.text != defaultMemeTopText
        let bottomTextChanged = memeTextBottom.text != defaultMemeBottomText
        UIVisibility(barVisibility: false, topTextVisibility: topTextChanged, bottomTextVisibility: bottomTextChanged)
        memeTextTop.resignFirstResponder()
        memeTextBottom.resignFirstResponder()
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // Returns the UI to the way it was
        UIVisibility(barVisibility: true, topTextVisibility: true, bottomTextVisibility: true)
        return memedImage
    }
    // Sets the visibility of portions of the UI in order to create the meme and then back
    func UIVisibility(barVisibility: Bool, topTextVisibility: Bool, bottomTextVisibility: Bool) {
        navBar.isHidden = !barVisibility
        toolbar.isHidden = !barVisibility
        memeTextTop.isHidden = !topTextVisibility
        memeTextBottom.isHidden = !bottomTextVisibility
    }
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = generateMeme()
        let shareActivityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        shareActivityController.completionWithItemsHandler = {(actityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            // Saves the meme if the meme was shared
            if completed {
                self.save(memedImage: memeImage)
            }
        }
        self.present(shareActivityController, animated: true, completion: nil)
    }
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: memeTextTop.text!, bottomText: memeTextBottom.text!, originalImage: memeImageView.image!, memeImage: memedImage)
    }
    @IBAction func cancelMeme(_ sender: Any) {
        memeTextTop.text = defaultMemeTopText
        memeTextBottom.text = defaultMemeBottomText
        memeImageView.image = nil
        shareButton.isEnabled = false
    }
}
