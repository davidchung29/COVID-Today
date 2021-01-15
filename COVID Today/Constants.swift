//
//  Constants.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import Foundation

//CONSTANTS FILE to manage Strings
struct K{
    struct Units{
        static let imperial = "imperial"
        static let metric = "metric"
    }
    struct Info {
        static let UVI = "UVI"
        static let Humidity = "Humidity"
        static let Pressure = "Pressure"
        static let WindSpeed = "Wind Speed"
        static let Visibility = "Visibility"
        static let DewPoint = "Dew Point"
        static let Sunrise = "Sunrise"
        static let Sunset = "Sunset"
        
    }
    struct URL{
        static let imperialURL = "https://api.openweathermap.org/data/2.5/weather?appid=d75fa73296a848712ab42e4e6c142a6a&units=imperial"
        static let metricURL = "https://api.openweathermap.org/data/2.5/weather?appid=d75fa73296a848712ab42e4e6c142a6a&units=metric"
    }
    struct lastUsed{
        static let cityName = "cityName"
        static let location = "location"
    }
    

}
