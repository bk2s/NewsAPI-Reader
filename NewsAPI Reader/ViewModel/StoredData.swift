//
//  StoredData.swift
//  NewsAPI Reader
//  Created by  Stepanok Ivan on 24.10.2021.

import Foundation

public class SData {
    static var countries: [Countries] = [
    Countries(id: "ae", countryName: "United Arab Emirates"),
    Countries(id: "ar", countryName: "Argentina"),
    Countries(id: "at", countryName: "Austria"),
    Countries(id: "au", countryName: "Australia"),
    Countries(id: "be", countryName: "Belgium"),
    Countries(id: "bg", countryName: "Bulgaria"),
    Countries(id: "br", countryName: "Brazil"),
    Countries(id: "ca", countryName: "Canada"),
    Countries(id: "ch", countryName: "Switzerland"),
    Countries(id: "cn", countryName: "China"),
    Countries(id: "co", countryName: "Colombia"),
    Countries(id: "cu", countryName: "Cuba"),
    Countries(id: "cz", countryName: "Czechia"),
    Countries(id: "de", countryName: "Germany"),
    Countries(id: "eg", countryName: "Egypt"),
    Countries(id: "fr", countryName: "France"),
    Countries(id: "gb", countryName: "United Kingdom"),
    Countries(id: "gr", countryName: "Greece"),
    Countries(id: "hk", countryName: "Hong Kong"),
    Countries(id: "hu", countryName: "Hungary"),
    Countries(id: "id", countryName: "Indonesia"),
    Countries(id: "ie", countryName: "Ireland"),
    Countries(id: "il", countryName: "Israel"),
    Countries(id: "in", countryName: "India"),
    Countries(id: "it", countryName: "Italy"),
    Countries(id: "jp", countryName: "Japan"),
    Countries(id: "kr", countryName: "Korea"),
    Countries(id: "lt", countryName: "Lithuania"),
    Countries(id: "lv", countryName: "Latvia"),
    Countries(id: "ma", countryName: "Morocco"),
    Countries(id: "mx", countryName: "Mexico"),
    Countries(id: "my", countryName: "Malaysia"),
    Countries(id: "ng", countryName: "Nigeria"),
    Countries(id: "nl", countryName: "Netherlands"),
    Countries(id: "no", countryName: "Norway"),
    Countries(id: "nz", countryName: "New Zealand"),
    Countries(id: "ph", countryName: "Philippines"),
    Countries(id: "pl", countryName: "Poland"),
    Countries(id: "pt", countryName: "Portugal"),
    Countries(id: "ro", countryName: "Romania"),
    Countries(id: "rs", countryName: "Serbia"),
    Countries(id: "ru", countryName: "Russian Federation"),
    Countries(id: "sa", countryName: "Saudi Arabia"),
    Countries(id: "se", countryName: "Sweden"),
    Countries(id: "sg", countryName: "Singapore"),
    Countries(id: "si", countryName: "Slovenia"),
    Countries(id: "sk", countryName: "Slovakia"),
    Countries(id: "th", countryName: "Thailand"),
    Countries(id: "tr", countryName: "Turkey"),
    Countries(id: "tw", countryName: "Taiwan"),
    Countries(id: "ua", countryName: "Ukraine"),
    Countries(id: "us", countryName: "United States of America"),
    Countries(id: "ve", countryName: "Venezuela"),
    Countries(id: "za", countryName: "South Africa")
    ]
    static var category: [String] = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
}


struct Countries {
    var id: String
    var countryName: String
}


struct SelectedSources {
    var sourceName: String
    var isSelected: Bool
}
