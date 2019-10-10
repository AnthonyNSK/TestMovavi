//
//  TableViewController.swift
//  TestMovavi
//
//  Created by user154783 on 05/10/2019.
//  Copyright © 2019 user154783. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var numberOfCellsDisplayed : Int = 0
    var fetchingMore : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.loadData()
        
    }

    func loadData() {
        let pars = Parser()
        if let url = URL(string: "https://habr.com/rss/hubs/all/") {
            pars.parseFeed(rssType: rssTypeDic["habr.com"], url: url) {
                OperationQueue.main.addOperation {
                    sortPosts()
                    if self.numberOfCellsDisplayed == 0 { self.increaseNumberOfCellsDisplayed() }
                     self.tableView.reloadData()
                }
              
            }
        }
        if let url = URL(string: "https://meduza.io/rss/podcasts/meduza-v-kurse") {
                   pars.parseFeed(rssType: rssTypeDic["meduza.io"], url: url) {
                       OperationQueue.main.addOperation {
                        sortPosts()
                        if self.numberOfCellsDisplayed == 0 { self.increaseNumberOfCellsDisplayed() }
                            self.tableView.reloadData()
                       }
                     
                   }
               }
        
    }
    
    func increaseNumberOfCellsDisplayed(){
        let newNumber = numberOfCellsDisplayed + 10
        while numberOfCellsDisplayed < newNumber  {
            if numberOfCellsDisplayed == posts.count - 1 {
                return
            }
            numberOfCellsDisplayed += 1
        }
        return
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfCellsDisplayed
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
         let item = posts[indexPath.row]
            cell.item = item
        

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        
        tableView.beginUpdates()
        cell.advancedMode()
        tableView.endUpdates()
    }
    
    //MARK: - Pagination

        
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offSetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                if (numberOfCellsDisplayed + 10) <= posts.count{
                    loadCells()
                }
            }
        }
    }
    
    func loadCells() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.numberOfCellsDisplayed += 10
            self.fetchingMore = false
            self.tableView.reloadData()
        }
    }
    
}
