//
//  MemeCollectionTableViewCell.swift
//  MemeMe
//
//  Created by Nathaniel Warner on 3/22/18.
//  Copyright © 2018 Nathaniel Warner. All rights reserved.
//

import UIKit

class MemeCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
