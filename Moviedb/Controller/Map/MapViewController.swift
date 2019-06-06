//
//  MapViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 6/4/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
class MapViewController: UIViewController , CLLocationManagerDelegate{
    var origin : String!
    var destination : String!
    var latitude : Double!
    var longtitude : Double!
    var namePlace : String = "default"
    var myLocation : CLLocation!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
//    let path = GMSMutablePath()
    func getLocation(location : String, place : String){
        print(location)
        self.destination = location
        var strArray = location.components(separatedBy: ",")
        let lat = strArray[0]
        let long = strArray[1]
        if let lat = Double(lat), let long = Double(long){
            self.latitude = lat
            self.longtitude = long
            self.namePlace = place
            
        }
        
    }
    @IBOutlet weak var vMap : UIView!
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyBvrL-a-BfYONkzLV9KmlzNaEcp2bc0iC4")
        GMSPlacesClient.provideAPIKey("AIzaSyBvrL-a-BfYONkzLV9KmlzNaEcp2bc0iC4")
        tabBarController?.tabBar.isHidden = true
        setUpNavigationBar()
        setUpMap()
        //installize location    manager
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }

    func setUpMap(){
        
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 28.524555 , longitude: 77.275111, zoom: 14.0)
        let mapView = GMSMapView(frame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view = mapView

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        let location = CLLocationCoordinate2D(latitude: 28.524555, longitude: 77.275111)
        marker.position = location
        marker.title = "vinova"
        marker.map = mapView
        
    }
    
    func setUpNavigationBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .orange
    }
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            self.myLocation = location
            let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 17.0)
            
            self.mapView?.animate(to: camera)
            //setUpMap(currentLoccation: location)
        }
        
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
        
    }

}
//extension MapViewController: CLLocationManagerDelegate {
//
//    // Handle incoming location events.
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location: CLLocation = locations.last!
//        print("Location: \(location)")
//
//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                              longitude: location.coordinate.longitude,
//                                              zoom: zoomLevel)
//
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }
//
////        listLikelyPlaces()
//    }
//
//    // Handle authorization for the location manager.
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .restricted:
//            print("Location access was restricted.")
//        case .denied:
//            print("User denied access to location.")
//            // Display the map using the default location.
//            mapView.isHidden = false
//        case .notDetermined:
//            print("Location status not determined.")
//        case .authorizedAlways: fallthrough
//        case .authorizedWhenInUse:
//            print("Location status is OK.")
//        }
//    }
//
//    // Handle location manager errors.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        print("Error: \(error)")
//    }
//}
//
//draw map
//        path.add(location)
//        // draw path
//        //path.add(myLocation.coordinate)
//        path.add(CLLocationCoordinate2D(latitude: 10.761167, longitude: 106.674808))
//        let rectangle = GMSPolyline(path: path)
//        rectangle.map = mapView
//        print(path)

//Setting the start and end location
//        origin = "\(10.834810),\(106.687774)"
//        let destination = "\(latitude),\(longtitude)"
//        origin = String(origin)
//        destination = String(destination)

//        origin = "\(10.741644),\(106.701161)"
//        destination = "\(10.761167),\(106.674808)"

//         origin = "\(28.524555),\(77.275111)"
//         destination = "\(28.643090),\(77.218280)"
//        let origin = CLLocationCoordinate2D(latitude: 10.761167, longitude: 106.674808)
//        let destination = CLLocationCoordinate2D(latitude: 12.761167, longitude: 109.674808)
//let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
//        let apiKey = "AIzaSyBZNyJsnu-IWO7iuCFegWw1hegQzJrMgXU"
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&key=%@"
//        let urlString = String(format: url, origin, destination, apiKey)
//        print(urlString)
//        Alamofire.request(urlString).responseJSON { (response) in
//            //print(response)
//            if response.result.isSuccess{
//                if let responeValue = response.result.value as? [String: Any]{
//                    print(response)
//                    if let routes = responeValue["routes"] as? [[String: Any]]{
////                        print(routes)
//                        for route in routes{
//                            if let overViewPolyline = route["overview_polyline"] as? [String : Any]{
////                                print(overViewPolyline)
//                                if let points = overViewPolyline["points"] as? String{
////                                    print(points)
//                                    let path = GMSPath.init(fromEncodedPath: points)
//                                    let polyline = GMSPolyline.init(path: path)
//                                    polyline.strokeColor = UIColor.blue
//                                    polyline.strokeWidth = 4
//                                    polyline.map = mapView
//
//                                }
//                            }
//                        }
//                    }
//
//                }
//
//            }else{
//                print("error")
//            }
//        }// end request
