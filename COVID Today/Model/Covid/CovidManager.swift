//
//  CovidManager.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import Foundation
import CoreLocation


protocol covidManagerDelegate {
    func didUpdateCovid(_ covidManager: covidManager, covidInfo: covidModel)
    func didFailCovid(error: Error)
}


struct covidManager{
    var delegate: covidManagerDelegate?
    let covidURL1 = "https://api.covidactnow.org/v2/county/"
    let covidURL2 = ".json?apiKey=a5f296125a084cd6b91658d2b7baa5d8"
    func fetchCovid(fipsCode: String) {
        let urlString = "\(covidURL1)\(fipsCode)\(covidURL2)"
        performRequest(with: urlString)
        print("fetched URL")
        print(urlString)
    }
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("perform request covid unsucessful")
                    self.delegate?.didFailCovid(error: error!)
                    return

                }
                if let safeData = data {
                    if let covidData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCovid(self, covidInfo: covidData)
                        print("perform request covid Sucess!")
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ dataInfo: Data) -> covidModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(covidData.self, from: dataInfo)
            let infectionRate = decodedData.metrics.infectionRate
            let caseDensity = decodedData.metrics.caseDensity
            let newCases = decodedData.actuals.newCases
            let covidInfo = covidModel(InfectionRate: infectionRate, CaseDensity: caseDensity, NewCases: newCases)
            print("parseJson covid success")
            return covidInfo
            
        } catch {
            delegate?.didFailCovid(error: error)
            print("parseJson covid error")
            return nil
        }
    }
}
