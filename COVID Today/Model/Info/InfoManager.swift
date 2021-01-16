//
//  InfoManager.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//
// Info files retrieve additional weather related information for the selected user location.


import Foundation
import CoreLocation

protocol infoManagerDelegate {
    func didUpdateWeatherInfo(_ infoManager: InfoManager, weatherInfo: infoModel)
    func didFailWithInfo(error: Error)
}

struct InfoManager{
    var delegate: infoManagerDelegate?
    let infoURL = "https://api.openweathermap.org/data/2.5/onecall?&appid=d75fa73296a848712ab42e4e6c142a6a&units=imperial"
    func fetchInfoWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(infoURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
        print("fetched URL")
        print(urlString)
    }
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("performrequest Info unsucessful")
                    self.delegate?.didFailWithInfo(error: error!)
                    return

                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeatherInfo(self, weatherInfo: weather)
                        print("performrequest Info Sucess!")
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ dataInfo: Data) -> infoModel? {
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(infoData.self, from: dataInfo)
            let sunrise = decodedData.current.sunrise
            let sunset = decodedData.current.sunset
            let temperature = decodedData.current.temp
            let feelsLike = decodedData.current.feels_like
            let pressure = decodedData.current.pressure
            let humidity = decodedData.current.humidity
            let uvi = decodedData.current.uvi
            let wind_speed = decodedData.current.wind_speed
            let visibility = decodedData.current.visibility
            let dewPoint = decodedData.current.dew_point
            
            let weatherInfo = infoModel(Sunrise: sunrise, Sunset: sunset, Temperature: temperature, FeelsLike: feelsLike, Pressure: pressure, Humidity: humidity, uviValue: uvi, windSpeed: wind_speed, Visibility: visibility, DewPoint: dewPoint)
            print("parseJSON info success!")
            return weatherInfo

        } catch {
            
            delegate?.didFailWithInfo(error: error)
            print("parse Json info error")
            return nil
        }
    }
}

