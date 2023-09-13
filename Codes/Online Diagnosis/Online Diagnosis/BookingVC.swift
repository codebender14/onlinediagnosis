//
//  BookingVC.swift
//  Online Diagnosis
//
//  Created by Naga Akhil Chaparala on 9/7/23.
//

import UIKit
import MapKit
import CoreLocation

class BookingVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeButton: UIButton!
    
    var isSatelliteView = false
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up location manager and request authorization
        locationManager.delegate = self
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.mapType = .standard
    }
    @IBAction func toggleMapType(_ sender: UIButton) {
        // Toggle between standard and satellite map views.
        if isSatelliteView {
            mapView.mapType = .standard
        } else {
            mapView.mapType = .satellite
        }
        // Toggle the flag.
        isSatelliteView.toggle()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Center the map on the user's location
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                mapView.setRegion(region, animated: true)

            // Add a blue location marker
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Current Location"
            mapView.addAnnotation(annotation)

            // Fetch and display nearby hospitals (replace with actual data source)
            let hospitalAnnotations = fetchNearbyHospitals(userLocation: location.coordinate)
            mapView.addAnnotations(hospitalAnnotations)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location error
        print("Location error: \(error.localizedDescription)")
    }

    // Replace this function with actual data fetching from a data source (e.g., API)
    func fetchNearbyHospitals(userLocation: CLLocationCoordinate2D) -> [MKPointAnnotation] {
        // Example: You should replace this with actual data retrieval logic
        let hospital1 = MKPointAnnotation()
        hospital1.coordinate = CLLocationCoordinate2D(latitude: 40.3258612, longitude: -94.8789506)
        hospital1.title = "Mosaic Medical Center"

        let hospital2 = MKPointAnnotation()
        hospital2.coordinate = CLLocationCoordinate2D(latitude: 40.36415, longitude: -94.8764202)
        hospital2.title = "Elevate Holistics Medical Marijuana Doctors"
        
        let hospital3 = MKPointAnnotation()
        hospital3.coordinate = CLLocationCoordinate2D(latitude: 40.3228529, longitude: -94.8803085)
        hospital3.title = "Continuum Family Care"
        
        let hospital4 = MKPointAnnotation()
        hospital4.coordinate = CLLocationCoordinate2D(latitude: 40.3231974, longitude: -94.885539)
        hospital4.title = "Mosaic Vascular Surgery - Maryville"
        
        let hospital5 = MKPointAnnotation()
        hospital5.coordinate = CLLocationCoordinate2D(latitude: 40.3206404, longitude: -94.8926314)
        hospital5.title = "The Source Medical Clinic"
        
        let hospital6 = MKPointAnnotation()
        hospital6.coordinate = CLLocationCoordinate2D(latitude: 40.3206404, longitude: -94.8926314)
        hospital6.title = "Mosaic Walk-in Clinic - Maryville"
        
        let hospital7 = MKPointAnnotation()
        hospital7.coordinate = CLLocationCoordinate2D(latitude: 40.3206404, longitude: -94.8926314)
        hospital7.title = "Family Guidance Family"
        
        let hospital8 = MKPointAnnotation()
        hospital8.coordinate = CLLocationCoordinate2D(latitude: 40.3206404, longitude: -94.8926314)
        hospital8.title = "Mullock Health Care LLC"

        return [hospital1, hospital2, hospital3, hospital4, hospital5, hospital6, hospital7, hospital8]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Handle annotation selection (e.g., show directions and hospital info)
        if let annotation = view.annotation as? MKPointAnnotation {
            // Replace with your logic to display directions and info for the selected hospital
            showDirectionsToHospital(hospital: annotation)
        }
    }
    
    func showDirectionsToHospital(hospital: MKPointAnnotation) {
        // You can present a UIAlertController with options for directions and hospital info
        let alertController = UIAlertController(title: hospital.title, message: "What would you like to do?", preferredStyle: .actionSheet)
        
        // Directions option
        alertController.addAction(UIAlertAction(title: "Get Directions", style: .default) { _ in
            // Open Apple Maps with directions to the hospital
            let placemark = MKPlacemark(coordinate: hospital.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = hospital.title
            mapItem.openInMaps()
        })
        
        // Hospital info option
        alertController.addAction(UIAlertAction(title: "Hospital Info", style: .default) { _ in
            // Present hospital information view or screen
            self.presentHospitalInfo(for: hospital)
        })
        
        // Cancel option
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentHospitalInfo(for hospital: MKPointAnnotation) {
        // You can implement a view controller to display hospital information here
        // Example: Create a new view controller, set hospital info, and present it
        let hospitalInfoVC = HospitalInfoVC()
        hospitalInfoVC.hospitalName = hospital.title
        // Set other hospital information properties here
        navigationController?.pushViewController(hospitalInfoVC, animated: true)
    }

}
