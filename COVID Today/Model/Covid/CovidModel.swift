//
//  CovidModel.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import Foundation

struct covidModel: Decodable{
    let InfectionRate: Double
    let CaseDensity: Double
    
    var InfectionRateString:String{
        String(format: "%.3f", InfectionRate)
    }
    var CaseDensityString: String{
        String(format: "%.3f", CaseDensity)
    }
    
    var CaseDensitySafety: String{
        switch CaseDensity {
        case 0..<5:
            return "Low"
        case 5..<50:
            return "Moderate"
        case 50...100:
            return "High"
        default:
            return "Very High"
        }
    }
}
