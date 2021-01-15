//
//  WeatherModel.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import Foundation

struct WeatherModel{
    let lat: Double
    let lon: Double
    
    let conditionId: Int
    let cityName:String
    let temperature: Double
    
    var temperatureString: String{
        String(format: "%.1f", temperature)
    }
    var conditionName: String{
        switch conditionId {
        case 200...202:
            return "cloud.bolt.rain"
        case 210...221:
            return "cloud.bolt"
        case 230...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.rain"
        case 511...531:
            return "cloud.heavyrain"
        case 600...602, 620...622:
            return "cloud.snow"
        case 611...616:
            return "cloud.sleet"
        case 701, 711, 731, 751, 761,762, 771 :
            return "sun.dust"
        case 741:
            return "cloud.fog"
        case 781:
            return "tornado"
        case 801...801:
            return "cloud"
        default:
            return "cloud"
        }
    }
    

}
