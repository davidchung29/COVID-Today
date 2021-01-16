//
//  getFipsManager.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//
// the Fips files are used to retrieve the user's state FIPS code in order to provide accurate and precise information for the user's area.


import Foundation
import CoreLocation

protocol getFipsManagerDelegate {
    func didUpdateFips(_ getFipsManager: getFipsManager, fipsInfo: getFipsModel)
    func didFailWithFips(error: Error)
}

struct getFipsManager{
    var delegate: getFipsManagerDelegate?
    let fipsURL = "https://geo.fcc.gov/api/census/block/find?showall=false&format=json"
    func fetchInfoFips(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(fipsURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
        print("fetched URL")
        print(urlString)
    }
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("perform request fips unsucessful")
                    self.delegate?.didFailWithFips(error: error!)
                    return

                }
                if let safeData = data {
                    if let fipsData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateFips(self, fipsInfo: fipsData)
                        print("perform request fips Sucess!")
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ dataInfo: Data) -> getFipsModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(getFipsData.self, from: dataInfo)
            let fips = decodedData.results[0].county_fips
            let fipsInfo = getFipsModel(fipsData: fips)
            print("parseJSON fips success!")
            
            return fipsInfo

        } catch {
            delegate?.didFailWithFips(error: error)
            print("parseJson fips error")
            return nil
        }
    }
}
