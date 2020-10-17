//
//  WeatherData.swift
//  Clima
//
//  Created by Tarokh on 8/6/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    
    // define some variables
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    
    // define some variables
    let temp: Double
    let pressure: Int
    let humidity: Int
    
}

struct Weather: Codable {
    
    // define some variables
    let id: Int
    let main: String
    let description: String
    let icon: String
    
}
