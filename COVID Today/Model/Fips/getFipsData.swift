//
//  getFipsData.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import Foundation

struct getFipsData: Decodable{
    let results: [Results]
}
struct Results:Decodable{
    let county_fips: String
}
