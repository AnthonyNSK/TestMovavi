//
//  Model.swift
//  TestMovavi
//
//  Created by user154783 on 03/10/2019.
//  Copyright © 2019 user154783. All rights reserved.
//

import Foundation
import UIKit

var posts: [Post] = []

struct Post {
    var title: String
    var description: String
    var pubDate: Date?
    var image: UIImage? = nil
    var source: String
}

let rssTypeDic:Dictionary<String,Int> = ["habr.com":1,"meduza.io":2]

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func sortPosts() {
    posts.sort(by: {$0.pubDate!.compare($1.pubDate!) == .orderedDescending})
}
