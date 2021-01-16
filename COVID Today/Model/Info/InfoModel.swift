//
//  InfoModel.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//


import Foundation

struct infoModel{
    let Sunrise: Double
    let Sunset: Double
    let Temperature: Double
    let FeelsLike: Double
    let Pressure: Int
    let Humidity: Int
    let uviValue: Double
    let windSpeed:Double
    let Visibility: Double
    let DewPoint: Double
    
    
    
    var TemperatureString: String{
        String(format: "%.1f", Temperature)
    }
    var FeelsLikeString: String{
        String(format: "%.1f", FeelsLike)
    }
    var PressureString: String{
        String(Pressure)
    }
    var HumidityString:String{
        String(Humidity)
    }
    var uviString: String{
        String(uviValue)
    }
    var windSpeedString: String{
        String(windSpeed)
    }
    var mphKnots: Int{
        Int(windSpeed*0.8689758)
    }
    var mpsKnots: Int{
        Int(windSpeed*1.9438445)
    }
    var visibilityString:String{
        String(Int(Visibility*0.0006213712))
    }
    
    var uviSafety:String{
        switch uviValue {
        case 0.0..<3.0:
            return "Low"
        case 3.0..<8.0:
            return "Moderate to High"
        default:
            return "Very High to Extreme"
        }
    }
    
    var humiditySafety:String{
        switch Humidity {
        case 45...55:
            return "Normal"
        case 0..<45:
            return "Dry"
        default:
            return "Humid"
        }
    }
    
    var windClassMPH:Int{
        switch mphKnots {
        case 0:
            return 0
        case 1...2:
            return 1
        case 3...7:
            return 2
        case 8...12:
            return 3
        case 13...17:
            return 4
        case 18...22:
            return 5
        case 23...27:
            return 6
        case 28...32:
            return 7
        case 33...37:
            return 8
        case 38...42:
            return 9
        case 43...47:
            return 10
        case 48...52:
            return 11
        case 53...57:
            return 12
        case 58...62:
            return 13
        case 63...67:
            return 14
        case 68...72:
            return 15
        case 73...77:
            return 15
        default:
            return 16
        }
    }
    var windClassMPS:Int{
        switch mpsKnots {
        case 0:
            return 0
        case 1...2:
            return 1
        case 3...7:
            return 2
        case 8...12:
            return 3
        case 13...17:
            return 4
        case 18...22:
            return 5
        case 23...27:
            return 6
        case 28...32:
            return 7
        case 33...37:
            return 8
        case 38...42:
            return 9
        case 43...47:
            return 10
        case 48...52:
            return 11
        case 53...57:
            return 12
        case 58...62:
            return 13
        case 63...67:
            return 14
        case 68...72:
            return 15
        case 73...77:
            return 15
        default:
            return 16
        }
    }

}
