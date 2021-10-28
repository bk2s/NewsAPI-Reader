//
//  MainViewModel.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 24.10.2021.
//

import Foundation

public struct Settings {
    static var selectedCountry = UserDefaults.standard.integer(forKey: "selectedCountry")
    static var selectedCategory = UserDefaults.standard.integer(forKey: "selectedCategory")
    static var filteringBy = UserDefaults.standard.integer(forKey: "filteringBy")
    static var sources: [String] = []
    static var selectedSources: [SelectedSources] = []
    static var needToLoad = true
    static var needToUpdateSources = true
    static var totalItems = 0
    static var loadAfter = 18
    static var isSorted = true
    static var selected = 0
}

class MainViewModel {
    public var newsData: [Article] = []
    public var page = 1
    public var progress: Float = 0
    public var loadedItems = 0
    public var totalResults = 0
    private var api = "6c23cc88aeef4748a94c235afc921639"
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
    
    
    func loadNews(complition: @escaping (_ newsData: Article)->()) {
        self.newsData = []
        self.page = 1
        totalResults = 0
        DispatchQueue.global().async {
            NR.loadNews(url: self.urlNews, urlParams: self.urlParamsNews) { newsData in
                var newData = newsData
                self.loadedItems = newData.articles?.count ?? 0
                print("All downloaded data")
                print(newData)
                DispatchQueue.global().async {
                    if newData.articles?.count != 0 {
                        for img in 0...newData.articles!.count-1 {
                            if let url = URL(string: newData.articles?[img].urlToImage ?? "") {
                                if let data = try? Data(contentsOf: url) {
                                    newData.articles?[img].image = data
                                }
                                DispatchQueue.main.async {
                                    self.totalResults += 1
                                    self.progress = Float(Double(self.totalResults) / Double(self.loadedItems))
                                    print("progress is: \(self.progress)")
                                    complition((newData.articles?[img])!)
                                    print("Picture № \(img) downloaded to model")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getSourses() {
        if Settings.needToUpdateSources {
            NR.generateSources(url: self.urlSources, urlParams: self.urlParams) { success in
                //
            }
        }
        Settings.needToUpdateSources = false
    }
    
    
    func loadMore(complition: @escaping (_ loadedData: Article)->()) {
        page += 1
        totalResults = 0
        print(self.urlParamsNews)
        NR.loadNews(url: self.urlNews, urlParams: self.urlParamsNews) { newsData in
            var loadedData = newsData
            self.loadedItems = loadedData.articles?.count ?? 0
            print("How many objects downloaded: \(loadedData.articles?.count)")
            DispatchQueue.global().async {
                if self.loadedItems != 0 {
                    if let count = loadedData.articles?.count {
                        for img in 0...count-1 {
                            if let url = URL(string: loadedData.articles![img].urlToImage ?? "") {
                                guard let data = try? Data(contentsOf: url) else { return }
                                loadedData.articles?[img].image = data
                            }
                            DispatchQueue.main.async {
                                self.totalResults += 1
                                self.progress = Float(Double(self.totalResults) / Double(self.loadedItems))
                                print("Picture № \(img) downloaded to model")
                                complition(loadedData.articles![img])
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func updateSources() {
        if Settings.needToUpdateSources {
            Settings.sources = []
            for source in 0...Settings.selectedSources.count-1 {
                if Settings.selectedSources[source].isSelected == true {
                    Settings.sources.append(Settings.selectedSources[source].sourceName)
                }
            }
        }
        Settings.needToUpdateSources = false
    }
}


