//
//  PageViewController.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 25.10.2021.
//

import UIKit

class PageViewController: UIViewController {
    
    public var newsData: Article?
    public var savedData: ArticleRealm?
    public var showSaved = false
    
    @IBOutlet weak var webPage: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if showSaved {
            title = savedData?.title ?? ""
            RealmController.loadItems()
            guard let urlString = savedData?.url else { return }
            loadFromUrl(url: urlString)
        } else {
            title = newsData?.title ?? ""
            guard let urlString = newsData?.url else { return }
            loadFromUrl(url: urlString)
        }
    }
    
    func loadFromUrl(url urlString: String) {
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        webPage.loadRequest(request)
    }
    
}



