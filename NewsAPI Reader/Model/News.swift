//
//  NetworkService.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 24.10.2021.
//

import Foundation

struct News : Codable {
    var articles : [Article]?
    let status : String?
    let totalResults : Int?
}

struct Article : Codable {
    let author : String?
    let content : String?
    let description : String?
    let publishedAt : String?
    let source : SourceFrom?
    let title : String?
    let url : String?
    let urlToImage : String?
    var image : Data?
    var saved : Bool?
    var isStarred: Bool?
    
    func urlToData(url: String) -> Data? {
        var image: Data?
        if let url = URL(string: url) {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else { return }
                image = data
            }
        }
        return image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
        source = try SourceFrom(from: decoder)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage)
        image = urlToData(url: urlToImage ?? "")
    }
    
    
    
    
}

struct SourceFrom : Codable {
    let id : String?
    let name : String?
}
