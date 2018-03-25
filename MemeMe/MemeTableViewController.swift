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
    // The collection of memes to be displayed in the collection view
    var memes: [Meme]!
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //MARK: View functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        tableView.reloadData()
        tableView.rowHeight = CGFloat(110.0)
    }
    //MARK: Table View functions
    //Number of items in table view function
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    //Populates the rows functions
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! MemeCollectionTableViewCell
        let meme = memes[indexPath.row]
        cell.memeTextLabel.text = "\(meme.topText) \(meme.bottomText)"
        cell.memeImageView.image = meme.memeImage
        return cell
    }
    //Action when a row within the table view is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailView.memeImage = memes[indexPath.row].memeImage
        navigationController?.pushViewController(memeDetailView, animated: true)
    }
    //Action to swipe to delete a meme
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            memes = appDelegate.memes
            tableView.reloadData()
        }
    }
}
