

import UIKit
import MapKit
import CoreLocation

class BookVC: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    var hospitalData : [[String:String]] = []
    var globeToggle = false

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        // Request location permissions
        locationManager.requestWhenInUseAuthorization()
        
        // Configure the map view
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getHospitalList()

    }
    
    @IBAction func globeTapped(_ sender: UIButton) {
           if globeToggle {
               mapView.mapType = .standard
           } else {
               mapView.mapType = .satellite
           }
           
           // Toggle the state
        globeToggle.toggle()
       }
    
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
            if annotation is MKUserLocation {
                       // Return nil for the user's location annotation
                       return nil
                   }
                   
                   // Use the custom annotation view for your custom annotations
                   if let customAnnotation = annotation as? CustomAnnotation {
                       let identifier = "CustomAnnotationView"
                       var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
                       
                       if annotationView == nil {
                           annotationView = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
                           annotationView?.canShowCallout = true
                       } else {
                           annotationView?.annotation = customAnnotation
                       }
                       
                       return annotationView
                   }
                   
                   return nil
         }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let customAnnotation = view.annotation as? CustomAnnotation {
            if let title = customAnnotation.title {
                showDirectionsToHospital(cordinate: customAnnotation.coordinate, title: title)
            }
        }
    }
        
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let userLocation = location.coordinate
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func showDirectionsToHospital(cordinate: CLLocationCoordinate2D, title: String) {
        // You can present a UIAlertController with options for directions and hospital info
        let alertController = UIAlertController(title: title, message: "What would you like to do?", preferredStyle: .actionSheet)
        
        // Directions option
        alertController.addAction(UIAlertAction(title: "Get Directions", style: .default) { _ in
            // Open Apple Maps with directions to the hospital
            let placemark = MKPlacemark(coordinate: cordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = title
            mapItem.openInMaps()
        })
        
        // Hospital info option
        alertController.addAction(UIAlertAction(title: "Hospital Info", style: .default) { _ in
            // Present hospital information view or screen
            self.presentHospitalInfo(titleValue:title)
        })
        
        // Cancel option
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentHospitalInfo(titleValue:String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "HospitalInfo" ) as! HospitalInfo
                
        vc.titleValue = titleValue
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func getHospitalList(){

        FireStoreManager.shared.getHospital { querySnapshot in
            var itemsArray = [String:String]()
            
            for (_,document) in querySnapshot.documents.enumerated() {
                itemsArray.updateValue(document.data()["hospitalName"] as! String, forKey: "hospitalName")
                itemsArray.updateValue(document.data()["latitude"] as! String, forKey: "latitude")
                itemsArray.updateValue(document.data()["longitude"] as! String, forKey: "longitude")

                self.hospitalData.append(itemsArray)
            }
            
            print(self.hospitalData)
            if self.hospitalData.count != 0 {
                self.updateMapView()
            }
        }
    }

    func updateMapView(){
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
            for item in self.hospitalData {
                let lat = Double(item["latitude"] ?? "0.0") ?? 0.0
                let long = Double(item["longitude"] ?? "0.0") ?? 0.0
                let annotation =  CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), title: item["hospitalName"], image: UIImage(named: "pin"))
                
                mapView.addAnnotation(annotation)
        }
        locationManager.startUpdatingLocation()
    }
}

