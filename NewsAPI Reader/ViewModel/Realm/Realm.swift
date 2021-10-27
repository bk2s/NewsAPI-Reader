//
//  Realm.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 27.10.2021.
//

import Foundation
import RealmSwift

class RealmController {
    
   static let realm = try! Realm()

    static var savedNews: Results<ArticleRealm>?
    
    
    static func saveItems(news: ArticleRealm) {
        do {
            try! realm.write{
                realm.add(news)
            }
        } catch {
            print(error)
        }
    }
    
   static func loadItems() {
        savedNews = realm.objects(ArticleRealm.self)
    }
    
   static func saveToRealm(sourceName: String, url: String, title: String, author: String, descr: String, image: Data) {
        var newItem = ArticleRealm()
        newItem.sourceName = sourceName
        newItem.url = url
        newItem.title = title
        newItem.author = author
        newItem.descriptionRealm = descr
        newItem.image = image
       newItem.isStarred = true
        saveItems(news: newItem)
    }
    
    static func deleteItem(num: Int) {
        
        if let item = savedNews?[num] {
            do {
                try self.realm.write {
                    realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    
    
    
}
