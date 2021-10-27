//
//  MainTableViewController.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 24.10.2021.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    private var mainModel = MainViewModel()
    
    @IBOutlet weak var loadingProgress: UIProgressView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var star: UIBarButtonItem!
    
    var showStarred: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Settings.selectedCategory)
        mainModel.getSourses()
        sortButton.isEnabled = false
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        RealmController.loadItems()
    }
    
    fileprivate func loadNews() {
        self.mainModel.loadNews { newsData in
            self.sortButton.isEnabled = false
            self.loadingProgress.isHidden = false
            self.loadingProgress.progress = self.mainModel.progress
            self.mainModel.newsData.append(newsData)
            print("Page updated")
            self.tableView.reloadData()
            
            if Double(self.mainModel.newsData.count) >= Double(self.mainModel.loadedItems - 2) {
                self.loadingProgress.isHidden = true
                self.sortButton.isEnabled = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Settings.needToLoad {
            loadNews()
            
            tableView.reloadData()
            loadingProgress.isHidden = true
            tableView.register(UINib(nibName: "NewsCell", bundle: nil) , forCellReuseIdentifier: "Cell")
            

        }
        Settings.needToLoad.toggle()
    }

    
    @IBAction func sortPressed(_ sender: UIBarButtonItem) {
        
        if Settings.isSorted {
            mainModel.newsData = mainModel.newsData.sorted(by: { $0.publishedAt! < $1.publishedAt! })
        tableView.reloadData()
            Settings.isSorted.toggle()
        } else {
            mainModel.newsData = mainModel.newsData.sorted(by: { $0.publishedAt! > $1.publishedAt! })
            tableView.reloadData()
            Settings.isSorted.toggle()
        }
        
    }
    
    
    
    @IBAction func showStars(_ sender: UIBarButtonItem) {
        
        showStarred.toggle()

        if showStarred {
            star.image = UIImage(systemName: "star.fill")
            tableView.reloadData()
            
        } else {
            star.image = UIImage(systemName: "star")
            loadNews()
        }

        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showStarred {
            return RealmController.savedNews?.count ?? 0
        } else {
        
        return mainModel.newsData.count
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell number \(indexPath.row) is loaded")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        if showStarred {
            let savedData = RealmController.savedNews?[indexPath.row]
            cell.authorLabel.text = savedData?.author
            cell.descriptionLabel.text = savedData?.descriptionRealm
            cell.sourceNameLabel.text = savedData?.sourceName
            cell.titleLabel.text = savedData?.title
            cell.imagePreviewLabel.image = UIImage(data: savedData!.image!)
            
        } else {
        
        let loadedData = mainModel.newsData[indexPath.row]
        cell.authorLabel.text = loadedData.author
        
        cell.descriptionLabel.text = loadedData.description
        cell.sourceNameLabel.text = loadedData.source?.name
        cell.titleLabel.text = loadedData.title
        print(loadedData.urlToImage)
        if let imageData = loadedData.image {
            cell.imagePreviewLabel.image = UIImage(data: imageData)
        }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == Settings.loadAfter {
            print("Load new data")
            Settings.loadAfter += 18
            print(Settings.loadAfter)
            mainModel.loadMore { loadedData in
                
                
                // Progress View ------------------------------------------------
                self.loadingProgress.isHidden = false
                self.sortButton.isEnabled = false
                if loadedData.title != nil {
                    self.mainModel.newsData.append(loadedData)
                    self.loadingProgress.progress = self.mainModel.progress
                    self.tableView.reloadData()
                    if Float((Double(self.mainModel.newsData.count - self.mainModel.loadedItems)  / Double( self.mainModel.loadedItems)) / Double(self.mainModel.page - 1)) >= 0.95 {
//                        if Double(self.mainModel.newsData.count) >= Double(self.mainModel.loadedItems - 2) {

                        self.loadingProgress.isHidden = true
                        self.sortButton.isEnabled = true

                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Settings.selected = indexPath.row
        performSegue(withIdentifier: "loadPage", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadPage" {
            let pageVC = segue.destination as! PageViewController
            
            if showStarred {
                //pageVC.isSaved = true
                //pageVC.savedData = RealmController.savedNews?[Settings.selected]
            } else {
            pageVC.newsData = mainModel.newsData[Settings.selected]
            }
            
        }
    }
    
    
}

