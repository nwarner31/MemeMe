//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Nathaniel Warner on 3/23/18.
//  Copyright © 2018 Nathaniel Warner. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    @IBOutlet weak var memeImageView: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = meme.memeImage
        tabBarController?.tabBar.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    //Go to the create meme view controller to edit the given meme
    @objc func editMeme() {
        let editViewController = storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as! CreateMemeViewController
        editViewController.savedMemeOriginalImage = meme.originalImage
        editViewController.savedMemeTopText = meme.topText
        editViewController.savedMemeBottomText = meme.bottomText
        present(editViewController, animated: true, completion: nil)
    }
}
