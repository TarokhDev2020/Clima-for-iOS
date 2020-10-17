//
//  ViewController.swift
//  Clima
//
//  Created by Tarokh on 8/5/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    
    
    //MARK: - Variables
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        requestForLocation()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WeatherViewController.dismissKeyboard))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
        weatherManager.delegate = self
        
        self.searchTextField.tag = 1
        self.searchTextField.delegate = self
        
        
    }

    //MARK: - Functions
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.weatherManager.fetchWeather(cityName: searchTextField.text!)
        self.view.endEditing(true)
    }
    
    private func requestForLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    

}

//MARK: - TextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = searchTextField.text {
            // fetch the weather
            self.weatherManager.fetchWeather(cityName: cityName)
        }
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.searchTextField.text == "" {
            self.searchTextField.placeholder = "Type something..."
            return false
        }
        else {
            return true
        }
    }
    
    @objc func dismissKeyboard() {
        self.searchTextField.endEditing(true)
    }
    
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didFailed(error: Error) {
        print(error.localizedDescription)
    }
    
    func updateWeather(weatherModel: WeatherModel) {
        self.temperatureLabel.text = weatherModel.temperatureString
        self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        self.cityNameLabel.text = weatherModel.name
    }
    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
