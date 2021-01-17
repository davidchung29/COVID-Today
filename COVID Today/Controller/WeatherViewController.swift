//
//  ViewController.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//
    
    
import UIKit
import CoreLocation
import PopupDialog
import AudioToolbox

class WeatherViewController: UIViewController, covidManagerDelegate,WeatherManagerDelegate{

    //MARK: - Initialize and Link up to Storyboard

    //Link Text Fields//
    @IBOutlet weak var searchTextField: UITextField!
    
    //Link Labels//
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var Health: UILabel!
    @IBOutlet weak var Risk: UILabel!
    
    //Link Views//
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var WeatherView: UIStackView!
    @IBOutlet weak var HealthView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var tempF: UIButton!
    @IBOutlet weak var tempC: UIButton!
    
    
    
    //Initialize Managers//
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var fipsManager = getFipsManager()
    var CovidManager = covidManager()
    var infoManager = InfoManager()
    
    //Create variables
    var CovidInfection: String?
    var CaseDensity: String?
    var newCases: String?
    var newCasesEval: String?
    var Vacc: String?
    
    var Date: String?
    var stringSunriseDate: String?
    var stringSunsetDate: String?
    
    var TemperatureString: String?
    var FeelsLikeString: String?
    
    var PressureString: String?
    
    var HumidityString: String?
    var humiditySafety: String?
    
    var uviString: String?
    var uviSafety: String?
    
    var windSpeed: String?
    var windClass: String?
    var knots: String?
    var visibility: String?
    var dewPoint: String?
    
    var lat: Double?
    var lon: Double?
    var currentCity: String?
    
    //create Layout for Table View
    lazy var InfoLayout: [Information] = []
    
    
    //Temp Style
    
    var dataUnit: String?
    var lastMethod: String?
    var tempUnitStr: String?
    
    // UX
    let generator = UIImpactFeedbackGenerator(style: .medium)
    let lgenerator = UIImpactFeedbackGenerator(style: .light)
    
    
//    var container: NSPersistentContainer!
//    let commit = Commit()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generator.impactOccurred()
        print("loaded")
        
        

        
        //design UI Elements
        HealthView.layer.cornerRadius = 35
        HealthView.layer.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.35).cgColor
        
        tableView.layer.cornerRadius = 35
        tableView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.35)
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self

        fipsManager.delegate = self
        CovidManager.delegate = self
        infoManager.delegate = self
        searchTextField.delegate = self
        
        
        tableView.dataSource = self
        //Creates Reusable cell for tableView with custom InfoCell
        tableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        //hides extra table view cells by createing a uiview over it
        tableView.tableFooterView = UIView()
        
        
        self.dataUnit = K.Units.imperial
//        container = NSPersistentContainer(name: "CoreModel")
//
//        container.loadPersistentStores { storeDescription, error in
//            if let error = error{
//                print("unresolved error \(error)")
//            }
//        }
//
//        commit.unitSystem = "metric"
    }
    
//    func saveContext() {
//        if container.viewContext.hasChanges {
//            do {
//                try container.viewContext.save()
//            } catch {
//                print("An error occurred while saving: \(error)")
//            }
//        }
//    }

    
    @IBAction func fPressed(_ sender: Any) {
        self.dataUnit = K.Units.imperial
        self.tempUnitStr = "°F"
        
        tempF.alpha = 1.0
        tempC.alpha = 0.4
        
        //haptic vibrate
        lgenerator.impactOccurred()
        
        if self.lastMethod == K.lastUsed.cityName{
            DispatchQueue.main.async {
                self.weatherManager.fetchWeather(cityName: self.currentCity ?? "San Francisco", units: self.dataUnit ?? K.Units.imperial)
                self.infoManager.fetchInfoWeather(latitude: self.lat ?? 0, longitute: self.lon ?? 0, units: self.dataUnit ?? K.Units.imperial)
                self.tableView.reloadData()
            }
        }else{
            DispatchQueue.main.async {
                self.weatherManager.fetchWeather(latitude: self.lat ?? 0, longitute: self.lon ?? 0, units: self.dataUnit ?? K.Units.imperial)
                self.infoManager.fetchInfoWeather(latitude: self.lat ?? 0, longitute: self.lon ?? 0, units: self.dataUnit ?? K.Units.imperial)
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func cPressed(_ sender: Any) {
        self.dataUnit = K.Units.metric
        self.tempUnitStr = "°C"
        
        tempF.alpha = 0.4
        tempC.alpha = 1.0
        
        //haptic vibrate
        lgenerator.impactOccurred()
        
        if self.lastMethod == K.lastUsed.cityName{
            DispatchQueue.main.async {
                self.weatherManager.fetchWeather(cityName: self.currentCity ?? "San Francisco", units: self.dataUnit ?? K.Units.imperial)
                self.infoManager.fetchInfoWeather(latitude: self.lat ?? 0, longitute: self.lon ?? 0, units: self.dataUnit ?? K.Units.imperial)
                self.tableView.reloadData()
            }
        }else{
            DispatchQueue.main.async {
                self.weatherManager.fetchWeather(latitude: self.lat ?? 0, longitute: self.lon ?? 0, units: self.dataUnit ?? K.Units.imperial)
                self.infoManager.fetchInfoWeather(latitude: self.lat ?? 0, longitute: self.lon ?? 0, units: self.dataUnit ?? K.Units.imperial)
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
    
    //info Button for POP-UP
    @IBAction func infoButton(_ sender: Any) {
        
        let title = "COVID Information"
        let message = (newCasesEval ?? " ") + " " + (newCases ?? "0") + " Cases"
        let buttonOne = CancelButton(title: "Cancel") {
            print("You canceled the car dialog.")
        }
        
        //haptic
        lgenerator.impactOccurred()
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        
        let dialogAppearance = PopupDialogDefaultView.appearance()

        dialogAppearance.titleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        dialogAppearance.titleFont =  .systemFont(ofSize: 25)
        dialogAppearance.messageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        dialogAppearance.messageFont = .systemFont(ofSize: 15)
        
        CancelButton.appearance().titleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        
        
        
        let containerAppearance = PopupDialogContainerView.appearance()
        containerAppearance.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.70)
        containerAppearance.cornerRadius = 35
        
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.blurRadius      = 30
        ov.liveBlurEnabled = true
        ov.opacity         = 0.7
        ov.color           = .black
        // Create buttons
        popup.addButtons([buttonOne])
        
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    //This function is called when WEATHER is UPDATED
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = "\(weather.temperatureString)" + (self.tempUnitStr ??  "°F")
            self.cityLabel.text = weather.cityName
            self.lat = weather.lat
            self.lon = weather.lon
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    //This function is called when the COVID data is UPDATED
    func didUpdateCovid(_ covidManager: covidManager, covidInfo: covidModel) {
        DispatchQueue.main.async {
                
            self.Health.text = "\(covidInfo.CaseDensitySafety)"
            self.Risk.text = " \(covidInfo.InfectionRateString)% "
            self.CovidInfection = covidInfo.InfectionRateString
            self.CaseDensity = covidInfo.CaseDensityString
            self.newCases = covidInfo.NewCasesString
            self.newCasesEval = covidInfo.NewCaseEval
            
            
                
            self.tableView.reloadData()
        }
             
    }
    
    func didFailCovid(error: Error) {
        print(error)
    }
    
    
// Uncomment the section below to SEND DATA to a DIFFERENT VIEW CONTROLLER
//    @IBAction func viewDataPressed(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "goToInfo", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToInfo"{
//            let destinationVC = segue.destination as! infoViewController
//            destinationVC.Risk = CovidInfection
//            destinationVC.caseDensity = CaseDensity
//            destinationVC.Date = Date
//            destinationVC.stringSunriseDate = stringSunriseDate
//            destinationVC.stringSunsetDate = stringSunsetDate
//            destinationVC.TemperatureString = TemperatureString
//            destinationVC.FeelsLikeString = FeelsLikeString
//            destinationVC.PressureString = PressureString
//            destinationVC.HumidityString = HumidityString
//            //destinationVC.humiditySafety = humiditySafety
//            destinationVC.uviString = uviString
//            destinationVC.uviSafety = uviSafety
//            destinationVC.windSpeed = windSpeed
//            destinationVC.visibility = visibility
//            destinationVC.dewPoint = dewPoint
//        }
//    }
    

}

//MARK: - UITableViewDataSource
//Creates and uses reusable cell for tableView
extension WeatherViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return InfoLayout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! InfoCell
        
        //sets TEXT for each reusable tableView CELL
        cell.infoLabel.text = InfoLayout[indexPath.row].body
        cell.infoDescription.text = InfoLayout[indexPath.row].sender
        
        
        //SETS IMAGE for each reusable tableView CELL based on the cell identifier/sender
        switch InfoLayout[indexPath.row].sender {

        case K.Info.UVI:
            cell.infoView?.image = #imageLiteral(resourceName: "UVI")
        case K.Info.Humidity:
            cell.infoView?.image = #imageLiteral(resourceName: "Hygrometer")
        case K.Info.Pressure:
            cell.infoView?.image = #imageLiteral(resourceName: "pressure")
        case K.Info.WindSpeed:
            cell.infoView?.image = UIImage(named: "Wind\(windClass ?? "0")" )
        case K.Info.Visibility:
            cell.infoView?.image = #imageLiteral(resourceName: "Visibility")
        case K.Info.DewPoint:
            cell.infoView?.image = #imageLiteral(resourceName: "dewPoint")
        case K.Info.Sunrise:
            cell.infoView?.image = #imageLiteral(resourceName: "sunrise")
        case K.Info.Sunset:
            cell.infoView?.image = #imageLiteral(resourceName: "sunset")
            
        default:
            print("unknown sender")
        }
            
        return cell
        
    }
    
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //searchTextField.endEditing(true)
        
        lgenerator.impactOccurred()
        searchTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            self.tableView.reloadData()
            searchTextField.endEditing(true)
            return true
        } else {
            textField.placeholder = "Type something"
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            DispatchQueue.main.async {
                self.currentCity = String(city)
                self.weatherManager.fetchWeather(cityName: city, units: self.dataUnit ?? K.Units.imperial)
                self.infoManager.fetchInfoWeather(latitude: self.lat ?? 0, longitute: self.lon ?? 0, units: self.dataUnit ?? K.Units.imperial)
                
                self.lastMethod = K.lastUsed.cityName
                self.tableView.reloadData()
            }
            
        }
        
        searchTextField.text = ""
        
    }
}




//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
        lgenerator.impactOccurred()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: lon, units: self.dataUnit ?? K.Units.imperial)
            fipsManager.fetchInfoFips(latitude: lat, longitute: lon)
            infoManager.fetchInfoWeather(latitude: lat, longitute: lon, units: self.dataUnit ?? K.Units.imperial)
            self.lastMethod = K.lastUsed.location
            print("lat:\(lat), lon:\(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - infoManagerDelegate
extension WeatherViewController: infoManagerDelegate{

    func didUpdateWeatherInfo(_ infoManager: InfoManager, weatherInfo: infoModel) {
        DispatchQueue.main.async {
            let sunriseDate = NSDate(timeIntervalSince1970: weatherInfo.Sunrise)
            let sunsetDate = NSDate(timeIntervalSince1970: weatherInfo.Sunset)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm:ss a"
            let Date = dateFormatter.string(from: sunriseDate as Date)
            let stringSunriseDate = timeFormatter.string(from: sunriseDate as Date)
            let stringSunsetDate = timeFormatter.string(from: sunsetDate as Date)
            
            self.Date = "Date: \(Date)"
            self.stringSunriseDate = "\(stringSunriseDate)"
            self.stringSunsetDate = "\(stringSunsetDate)"
            
            self.TemperatureString = "\(weatherInfo.TemperatureString)" + (self.tempUnitStr ??  "°F")
            self.FeelsLikeString = "Feels like: \n \(weatherInfo.FeelsLikeString) " + (self.tempUnitStr ??  "°F")
            
            self.PressureString = "\(weatherInfo.PressureString)hPa"
            self.HumidityString = "\(weatherInfo.HumidityString)% \(weatherInfo.humiditySafety)"
            
            self.uviString = "\(weatherInfo.uviString)"
            self.uviSafety = "\(weatherInfo.uviSafety)"
            
            self.windSpeed = "\(weatherInfo.windSpeedString)"
            
            if self.dataUnit == K.Units.imperial{
                self.knots = "\(weatherInfo.mphKnots)"
                
                self.windClass = "\(weatherInfo.windClassMPH)"
            }
            if self.dataUnit == K.Units.metric{
                self.knots = "\(weatherInfo.mpsKnots)"
                
                self.windClass = "\(weatherInfo.windClassMPS)"
            }
            
            self.visibility = "\(weatherInfo.visibilityString)"
            self.dewPoint = "\(weatherInfo.DewPoint)" + (self.tempUnitStr ??  "°F")
            
            self.InfoLayout = [
                Information(sender: K.Info.UVI , body: "\(self.uviString ?? "----") \(self.uviSafety ?? "----")"),
                Information(sender: K.Info.Humidity, body: "\(self.HumidityString ?? "----")"),
                Information(sender: K.Info.Pressure, body: "\(self.PressureString ?? "----")"),
                Information(sender: K.Info.WindSpeed, body: "\(self.knots ?? "----") Knots"),
                Information(sender: K.Info.Visibility, body: "\(self.visibility ?? "----") Miles"),
                Information(sender: K.Info.DewPoint, body: "\(self.dewPoint ?? "-----")"),
                Information(sender: K.Info.Sunrise, body: "\(stringSunriseDate )"),
                Information(sender: K.Info.Sunset, body: "\(stringSunsetDate )")
            ]
            self.tableView.reloadData()

        }
    }
    func didFailWithInfo(error: Error) {
        print(error)
    }
}

//MARK: - getFipsManagerDelegate
extension WeatherViewController: getFipsManagerDelegate{
    func didUpdateFips(_ getFipsManager: getFipsManager, fipsInfo: getFipsModel) {
        DispatchQueue.main.async {
            self.CovidManager.fetchCovid(fipsCode: fipsInfo.fipsData)
        }
    }
    func didFailWithFips(error: Error) {
        print(error)
    }
}
