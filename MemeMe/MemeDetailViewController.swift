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
    var memeImage: UIImage!
    @IBOutlet weak var memeImageView: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeImage
    }
        
    
}
