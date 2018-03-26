//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Nathaniel Warner on 3/22/18.
//  Copyright © 2018 Nathaniel Warner. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // The collection of memes to be displayed in the collection view
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    //MARK: View function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
    }
    //MARK: Collection View functions
    //Size for individual cell functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameVariable = view.frame.width > view.frame.height ? view.frame.height : view.frame.width
        let cellDimension = (frameVariable - 60.0) / 3.0
        return CGSize(width: cellDimension, height: cellDimension)
    }
    //Spacing between rows function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20.0)
    }
    //Spacing between columns functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20.0)
    }
    //Border around the edge of collection view function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(CGFloat(20.0), CGFloat(10.0), CGFloat(20.0), CGFloat(10.0))
    }
    //Number of items in collection view function
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    //Populates the cells functions
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionCellCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memeImage
        return cell
    }
    //Action when a cell within the collection view is clicked
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailView.meme = memes[indexPath.row]
        navigationController?.pushViewController(memeDetailView, animated: true)
    }
}
