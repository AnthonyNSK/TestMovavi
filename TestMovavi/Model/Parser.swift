//
//  Parser.swift
//  TestMovavi
//
//  Created by user154783 on 03/10/2019.
//  Copyright © 2019 user154783. All rights reserved.
//

import Foundation
import SwiftSoup

class Parser: NSObject,XMLParserDelegate {
    
  //  var parser = XMLParser()
    
    private var currentElement = ""
    private var currentImagePath = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (() -> Void)?
    
     var rssType: Int?
    
    func parseFeed(rssType:Int?, url: URL, completionHandler: (() -> Void)?) {
        
        
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url:url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            self.rssType = rssType
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
         task.resume()
    }
    
    func setupDescription() {
        do {
            let text = try SwiftSoup.parse(currentDescription)
            for element in try text.select("img").array(){
                currentImagePath = try element.attr("src")
            }
            currentDescription = try text.text()
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
        
    }
    
    //MARK: - XMLParser Delegate
    
    func parser(_parser: XMLParser, parseErrorOccurred parseError: NSError) {
        print("Parse error: \(parseError.description)")
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentImagePath = ""
        }
        // inage from https://meduza.io/rss/podcasts/meduza-v-kurse
        if elementName == "itunes:image" {
            if let image = attributeDict["href"] {
                currentImagePath = image
            }
        }
        
    }
    
  
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if rssType == rssTypeDic["habr.com"] {
            setupDescription()
            }
            // Fri, 04 Oct 2019 15:36:46 GMT
            let dateFormatter = DateFormatter()
            var sourceNews = String()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
            let date = dateFormatter.date(from: currentPubDate)
            
            if rssType == rssTypeDic["habr.com"] {
                sourceNews = "habr.com"
            } else if rssType == rssTypeDic["meduza.io"] {
                sourceNews = "meduza.io"
            }
            
            var post = Post(title: currentTitle, description: currentDescription, pubDate: date, source: sourceNews)
            
            if let imageURL = URL(string: currentImagePath) {
                if let data = try? Data(contentsOf: imageURL) {
                    post.image = UIImage(data: data)
                }
            }
            
            DispatchQueue(label: "Secure array writing").sync {
                posts.append(post)
            }
            }
        }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
            switch currentElement {
            case "title": currentTitle += string
            case "description" : currentDescription += string
            case "pubDate": currentPubDate += string
            default: break
            }
    }
        
        func parserDidEndDocument(_ parser: XMLParser) {
            parserCompletionHandler?()
        }
        
}
