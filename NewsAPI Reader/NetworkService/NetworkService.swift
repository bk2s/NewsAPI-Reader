//
//  NetworkService.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 24.10.2021.
//

import Foundation
import Alamofire
import SwiftUI

public class NR {
    
    static var mainModel = MainViewModel()

    static func generateSources(url: String, urlParams: [String: String], complition: @escaping(_ success: Bool) -> Void) {
        Settings.selectedSources = []
        var sources: [String] = []
        AF.request(url, method: .get, parameters: urlParams).validate().response { (responce) in
            guard let data = responce.data else {return}
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Sources.self, from: data)
                print("Вот источники медиа")
                print(decodedData)
                guard let decoded = decodedData.sources else {return}
                if decoded.count != 0 {
                    for num in 0...decoded.count-1 {
                        sources.append(decoded[num].id!)
                        Settings.selectedSources.append(SelectedSources(sourceName: decoded[num].id!, isSelected: true))
                    }
                    self.mainModel.updateSources()
                    print("All sources in one place: \(Settings.selectedSources)")
                    complition(true)
                } else {
                    print("Sources is nil")
                    Settings.sources = []
                    complition(true)

                }
                
            } catch let error{
                print(error)
            }
        }
    }
    
    
    static func loadNews(url: String, urlParams: [String : String], complition: @escaping(_ newsData: News)->()) {
        AF.request(url, method: .get, parameters: urlParams).validate().responseString(encoding: .utf8) { (responce) in
            guard let data = responce.data else {return}
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(News.self, from: data)
                complition(decodedData)
            } catch let error {
                print(error)
            }
        }
    }
}
