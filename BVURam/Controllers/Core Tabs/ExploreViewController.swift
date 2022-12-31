//
//  Explore.swift
//  BVURam
//
//  Created by Vardhan Chopada on 12/22/22.
//

import UIKit
import MapKit
import CoreLocation

class ExploreViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

   
    @IBOutlet var searchField: UITextField!
    @IBOutlet var getDirections: UIButton!
    @IBOutlet var mapKit: MKMapView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    

    @IBAction func getDirections(_ sender: Any) {
        getAddress()
    }
    
    private func getAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchField.text ?? "") { placemarks, error in
            guard let placemarks = placemarks, let location = placemarks.first?.location
            else {
                print("No Location")
                return
            }
            print(location)
            self.mapThis(destinationCordinate: location.coordinate)
        }
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    
    private func mapThis(destinationCordinate: CLLocationCoordinate2D) {
        let sourceCordinate = (locationManager.location?.coordinate)!
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Something went wrong")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapKit.addOverlay(route.polyline)
            self.mapKit.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
}


