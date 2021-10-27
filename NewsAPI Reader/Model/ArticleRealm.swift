//
//  ArticleRealm.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 27.10.2021.
//

import Foundation
import RealmSwift


class ArticleRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var sourceName: String = ""
    @objc dynamic var descriptionRealm: String = ""
    @objc dynamic var image: Data?
    @objc dynamic var url: String = ""
    @objc dynamic var isStarred: Bool = true
}

