//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Nathaniel Warner on 3/22/18.
//  Copyright © 2018 Nathaniel Warner. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    //var refreshControl = UIRefreshControl() as UIRefreshControl!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.rowHeight = CGFloat(110.0)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! MemeCollectionTableViewCell
        let meme = memes[indexPath.row]
        cell.memeTextLabel.text = "\(meme.topText) \(meme.bottomText)"
        cell.memeImageView.image = meme.originalImage
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
