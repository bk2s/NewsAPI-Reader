//
//  MainTableViewController.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 24.10.2021.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    private var mainModel = MainViewModel()
    private var newsData: [Article] = []
    private var totalItems = 0
    private var loadAfter = 18
    private var isSorted = true
    private var selected = 0
    @IBOutlet weak var loadingProgress: UIProgressView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainModel.getSourses()
        sortButton.isEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Settings.needToLoad {
        
        newsData = []
        tableView.reloadData()
        mainModel.page = 1
        loadingProgress.isHidden = true
        tableView.register(UINib(nibName: "NewsCell", bundle: nil) , forCellReuseIdentifier: "Cell")

        self.mainModel.loadNews { newsData in
            
            // Progress View ------------------------------------------------
            self.sortButton.isEnabled = false
            self.loadingProgress.isHidden = false
            self.loadingProgress.progress = Float(Double(self.newsData.count) / Double(self.mainModel.loadedItems))
            self.newsData.append(newsData)
            
            print("Page updated")
            self.tableView.reloadData()
            
            if Double(self.newsData.count) >= Double(self.loadAfter - 2) {
                self.loadingProgress.isHidden = true
                self.sortButton.isEnabled = true
            }
        }
        }
        Settings.needToLoad.toggle()
    }

    
    @IBAction func sortPressed(_ sender: UIBarButtonItem) {
        
        if isSorted {
        newsData = newsData.sorted(by: { $0.publishedAt! < $1.publishedAt! })
        tableView.reloadData()
            isSorted.toggle()
        } else {
            newsData = newsData.sorted(by: { $0.publishedAt! > $1.publishedAt! })
            tableView.reloadData()
            isSorted.toggle()
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell number \(indexPath.row) is loaded")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        let loadedData = newsData[indexPath.row]
        cell.authorLabel.text = loadedData.author
        
        cell.descriptionLabel.text = loadedData.description
        cell.sourceNameLabel.text = loadedData.source?.name
        cell.titleLabel.text = loadedData.title
        print(loadedData.urlToImage)
        if let imageData = loadedData.image {
            cell.imagePreviewLabel.image = UIImage(data: imageData)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == loadAfter {
            print("Load new data")
            loadAfter += 18
            print(loadAfter)
            mainModel.loadMore { loadedData in
                
                
                // Progress View ------------------------------------------------
                self.loadingProgress.isHidden = false
                self.sortButton.isEnabled = false
                if loadedData.title != nil {
                    self.newsData.append(loadedData)
                    self.loadingProgress.progress = Float((Double(self.newsData.count - self.mainModel.loadedItems)  / Double( self.mainModel.loadedItems)) / Double(self.mainModel.page - 1))
                    self.tableView.reloadData()
                    if Float((Double(self.newsData.count - self.mainModel.loadedItems)  / Double( self.mainModel.loadedItems)) / Double(self.mainModel.page - 1)) >= 0.95 {
                        self.loadingProgress.isHidden = true
                        self.sortButton.isEnabled = true

                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "loadPage", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadPage" {
            let pageVC = segue.destination as! PageViewController
            
            pageVC.newsData = newsData[selected]
                
            
        }
    }
    
    
}

