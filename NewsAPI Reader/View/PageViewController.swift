//
//  PageViewController.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 25.10.2021.
//

import UIKit

class PageViewController: UIViewController {
    
    public var newsData: Article?
    
    @IBOutlet weak var webPage: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = newsData?.title ?? ""
        
        guard let urlString = newsData?.url else { return }
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        
        webPage.loadRequest(request)

        
        
        
        
        // Do any additional setup after loading the view.
    }
    

    
}
