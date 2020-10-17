//
//  WeatherManager.swift
//  Clima
//
//  Created by Tarokh on 8/6/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import Foundation
import Alamofire

protocol WeatherManagerDelegate {
    func didFailed(error: Error)
    func updateWeather(weatherModel: WeatherModel)
}

class WeatherManager {
    
    // define some variables
    var weatherModel: WeatherModel?
    var delegate: WeatherManagerDelegate?
    
    // define some functions
    func fetchWeather(cityName: String) {
        let url = Routes.baseURL + "&units=metric&q=\(cityName)"
        performRequest(with: url)
    }
    
    func fetchWeather(lat: Double, lon: Double) {
        let url = Routes.baseURL + "&units=metric&lat=\(lat)&lon=\(lon)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        let request = AF.request(urlString)
        request.responseJSON { (data) in
            if let safeData = data.data {
                if let weather = self.fetchJSON(data: safeData) {
                    self.delegate?.updateWeather(weatherModel: weather)
                }
            }
        }
    }
    
    func fetchJSON(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let conditionID = decodedData.weather[0].id
            let condition = decodedData.weather[0].description
            self.weatherModel = WeatherModel(name: name, temp: temp, conditionId: conditionID, condition: condition)
            return weatherModel
        }
        catch let jsonError as NSError {
            self.delegate?.didFailed(error: jsonError)
            return nil
        }
    }
    
}
