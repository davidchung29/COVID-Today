//
//  CovidData.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import Foundation

struct covidData: Decodable{
    let metrics: Metrics
}

struct Metrics: Decodable{
    let infectionRate: Double
    let caseDensity: Double
}
               
