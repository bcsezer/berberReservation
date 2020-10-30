//
//  locationViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 22.10.2020.
//

import UIKit
import MapKit
import CoreLocation
//41.048094, 29.002390
class locationViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    let latitue =  41.048094
    let longitude = 29.002390
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    func demoMap() {
        var coordinates = CLLocationCoordinate2D()
        coordinates.latitude = latitue
        coordinates.longitude = longitude
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        let a = MKPointAnnotation()
        a.coordinate = coordinates
        a.title = "By Makar , Adres: Türkali Mahallesi , Türkali, Köprü Sk. No:14/B1634357, Beşiktaş/İstanbul"
        
        mapView.addAnnotation(a)
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        demoMap()
        
    }
    
    //MARK:- CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(mRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    //MARK:- Intance Methods
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        
        
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let requestLocation = CLLocation(latitude: latitue, longitude: longitude)
        
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            //closure
            
            if let placemark = placemarks {
                if placemark.count > 0 {
                    print(placemark[0])
                    
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                    
                }
                
            }
            
            
        }
    }
}


