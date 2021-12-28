//
//  ViewController.swift
//  RainCheck
//
//  Created by Vishaal S on 27/12/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var latValue:Double = 0
    var longValue:Double = 0
    var result = "NOPE"
    
    let API_KEY:String = "" //put open weather api here.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    func checkRainStatus(){
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latValue)&lon=\(longValue)&appid=\(API_KEY)"
        print(url)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            do{
                let json = try JSONDecoder().decode(JSONResult.self, from: data!)
                if(json.weather[0].id >= 200 && json.weather[0].id <= 500){
                    self.result = "YUP"
                }
                print(json.weather[0].id)
                DispatchQueue.main.async {
                    self.processReq()
                }
            }
            catch{
                self.result = "Error"
                DispatchQueue.main.async {
                    self.processReq()
                }
            }
        })
        
        task.resume()
    }

    func processReq(){
        performSegue(withIdentifier: "goToResult", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if(identifier == "goToResult"){
                let destinationVC = segue.destination as! ResultViewController
                destinationVC.message = self.result
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}

        latValue = locValue.latitude
        longValue = locValue.longitude
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        let locStatus = locationManager.authorizationStatus
        
        switch locStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            checkRainStatus()
            return
        case .denied,.restricted:
            let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable location services in your Settings", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert,animated: true,completion: nil)
            return
        case .authorizedAlways,.authorizedWhenInUse:
            checkRainStatus()
            return
        default:
            return
        }
    }
    
}

