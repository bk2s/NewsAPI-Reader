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
}

struct SourceFrom : Codable {
    let id : String?
    let name : String?
}


//guard let url = loadedData.urlToImage else { return cell}
//let data = try? Data(contentsOf: URL(string: url)!)
//cell.imagePreviewLabel.image = UIImage(data: data!)
