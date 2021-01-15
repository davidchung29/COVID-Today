//
//  File.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String, units: String) {
        var urlString: String{
            if units == K.Units.imperial{
                return "\(K.URL.imperialURL)&q=\(cityName)"
            }else{
                return "\(K.URL.metricURL)&q=\(cityName)"
            }
        }
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees, units: String) {
        
        var urlString: String{
            if units == K.Units.imperial{
                return "\(K.URL.imperialURL)&lat=\(latitude)&lon=\(longitute)"
            }else{
                return "\(K.URL.metricURL)&lat=\(latitude)&lon=\(longitute)"
            }
        }
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let latitude = decodedData.coord.lat
            let longitude = decodedData.coord.lon
            
            let weather = WeatherModel(lat: latitude, lon: longitude, conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
