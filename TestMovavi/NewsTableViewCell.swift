//
//  NewsTableViewCell.swift
//  TestMovavi
//
//  Created by user154783 on 06/10/2019.
//  Copyright © 2019 user154783. All rights reserved.


import UIKit


class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var descriptionIsHidden = true
    
    
    var item : Post! {
        didSet {
            titleLabel.text = item.title
        
            sourceLabel.text = item.source
       
            let screenSize = UIScreen.main.bounds
            print(screenSize.size.width)
            if item.image != nil {
                let newImage = resizeImage(image: item.image!, newWidth: screenSize.size.width)
            postImageView.image = newImage
            } else { postImageView.image = nil}
        
            let formatter = DateFormatter()
            formatter.dateFormat  = "EEE, dd MMM yyyy HH:mm:ss"
            if item.pubDate != nil {
            pubDateLabel.text = formatter.string(from: item.pubDate!)
            }
        }
    }
    
    func advancedMode() {
        if descriptionIsHidden == true {
            descriptionIsHidden = false
            descriptionLabel.text = item.description
            descriptionLabel.isHidden = false
        } else {
            descriptionIsHidden = true
            descriptionLabel.text = ""
            descriptionLabel.isHidden = true
        }
    }
     
}



