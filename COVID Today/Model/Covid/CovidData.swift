//
//  CovidData.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import Foundation

struct covidData: Decodable{
    let metrics: Metrics
    let actuals: Actuals
}

struct Metrics: Decodable{
    let infectionRate: Double
    let caseDensity: Double
}
               
struct Actuals: Decodable{
    let newCases: Int
    //let vaccinesDistributed: Double
}
