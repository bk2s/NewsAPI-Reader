//
//  PageViewController.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 25.10.2021.
//

import UIKit

class PageViewController: UIViewController {
    
    public var newsData: Article?
    
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var webPage: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RealmController.loadItems()

        print(RealmController.savedNews)
        title = newsData?.title ?? ""
        
        guard let urlString = newsData?.url else { return }
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        
        webPage.loadRequest(request)

        
        if let saved = RealmController.savedNews {
        
            if saved.count > 0 {
            
        for des in 0...saved.count - 1 {
            if RealmController.savedNews![des].descriptionRealm == newsData?.description {
                starButton.image = UIImage(systemName: "star.fill")
                //starButton.isEnabled = false
            }
        }
        }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        
        if starButton.image == UIImage(systemName: "star.fill") {
            print("Удаляю запись")
            if let saved = RealmController.savedNews {
                var itemNum = 0
            for des in 0...saved.count - 1 {
                if RealmController.savedNews![des].descriptionRealm == newsData?.description {
                    RealmController.deleteItem(num: itemNum)
                    starButton.image = UIImage(systemName: "star")
                    //starButton.isEnabled = false
                }
                itemNum += 1

            }
            }

        } else {
        

        RealmController.saveToRealm(sourceName: newsData?.source?.name ?? "", url: newsData?.url ?? "", title: newsData?.title ?? "", author: newsData?.author ?? "", descr: newsData?.description ?? "", image: (newsData?.image!)! )
        

        
        starButton.image = UIImage(systemName: "star.fill")
    }
    }
    
}
