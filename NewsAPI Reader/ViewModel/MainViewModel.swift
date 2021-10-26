//
//  MainViewModel.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 24.10.2021.
//

import Foundation

struct Settings {
    static var selectedCountry = 51
    static var selectedCategory = 2
    static var sources: [String] = []
    static var needToLoad = true


}

 class MainViewModel {
    
    
    public var page = 1
    public var loadedItems = 0
    public var totalResults = 0
    private var api = "7cdf2921d0b04662b37aad0aa9eb8783"
    public var urlParams: [String : String] {
        let params = [
            "apiKey":api,
            "country": SData.countries[Settings.selectedCountry].id,
            "category": SData.category[Settings.selectedCategory]
        ]
        return params
    }
    private var urlParamsNews: [String : String] {
        get {
            if Settings.sources != [] {
                let params = [
                    "apiKey":api,
                    "page": String(page),
                    "sources": Settings.sources.joined(separator: ", ")
                ]
                return params
            }
            else {
                let params = [
                    "apiKey":api,
                    "country": SData.countries[Settings.selectedCountry].id,
                    "page": String(page),
                    "category": SData.category[Settings.selectedCategory]
                ]
                return params
            }
        }
    }

    
    public let urlSources = "https://newsapi.org/v2/top-headlines/sources"
    private let urlNews = "https://newsapi.org/v2/top-headlines"
    public var newsData: News!
    
    
      func loadNews(complition: @escaping (_ newsData: Article)->()) {
         DispatchQueue.global().async {
             NR.loadNews(url: self.urlNews, urlParams: self.urlParamsNews) { newsData in
                 var newData = newsData
                 self.totalResults = newData.totalResults ?? 0
                 self.loadedItems = newData.articles?.count ?? 0
                 print("Вот что получилось выудить")
                 print(newData)
                 DispatchQueue.global().async {
                     for img in 0...newData.articles!.count-1 {
                         if let url = URL(string: newData.articles?[img].urlToImage ?? "") {
                             if let data = try? Data(contentsOf: url) {
                                 newData.articles?[img].image = data
                             }
                             DispatchQueue.main.async {
                                 complition((newData.articles?[img])!)
                                 print("Picture № \(img) downloaded to model")
                             }
                         }
                     }
                 }
             }
         }
     }
     
     func getSourses() {
         NR.generateSources(url: self.urlSources, urlParams: self.urlParams) { success in
             //
         }
     }
    
    
    func loadMore(complition: @escaping (_ loadedData: Article)->()) {
        page += 1
        print(self.urlParamsNews)
        NR.loadNews(url: self.urlNews, urlParams: self.urlParamsNews) { newsData in
            var loadedData = newsData
            self.loadedItems = loadedData.articles?.count ?? 0
            print("Вот сколько объектов еще удалось вытащить: \(loadedData.articles?.count)")
            DispatchQueue.global().async {
                if let count = loadedData.articles?.count {
                for img in 0...count-1 {
                    if let url = URL(string: loadedData.articles![img].urlToImage ?? "") {
                        guard let data = try? Data(contentsOf: url) else { return }
                    loadedData.articles?[img].image = data
                    }
                    DispatchQueue.main.async {
                        print("Picture № \(img) downloaded to model")
                        complition(loadedData.articles![img])
                    }
                }
            }
            }
        }
    }
}


