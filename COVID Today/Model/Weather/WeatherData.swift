//
//  WeatherData.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import Foundation
 
struct WeatherData: Decodable{
    let name:String
    let main: Main
    let weather: [Weather]
    let coord: Coord
}

struct Main: Decodable{
    let temp: Double
}
struct Weather: Decodable{
    let description: String
    let id: Int
}
struct Coord:Decodable{
    let lon: Double
    let lat: Double
}

