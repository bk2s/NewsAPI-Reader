//
//  NetworkService.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 24.10.2021.
//

import Foundation

struct Sources : Codable {

    let sources : [Source]?
    let status : String?


}

struct Source : Codable {

    let category : String?
    let country : String?
    let description : String?
    let id : String?
    let language : String?
    let name : String?
    let url : String?

}
