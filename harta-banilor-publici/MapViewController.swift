import UIKit
import CoreLocation

/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var id: Int!
    
    init(position: CLLocationCoordinate2D, id: Int) {
        self.position = position
        self.id = id
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, GMUClusterManagerDelegate, GMSMapViewDelegate, CustomInfoWindowDelegate {
    private var kCameraLatitude = 44.42
    private var kCameraLongitude = 26.09

    @IBOutlet var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    private var customInfoWindow: CustomInfoWindow!
    
    private var tappedMarker: GMSMarker?
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private var api: ApiHelper!
    private var institutionSummary: InstitutionSummary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = ApiHelper()
        
        setupGoogleMaps()
        setupMarkerClustering()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.determineMyCurrentLocation()
        })
    }
    
    func setupGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 12)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }

        self.view = mapView
    }
    
    func setupMarkerClustering() {
        // Set up the cluster manager with default icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        populateMap()
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        clusterManager.cluster()
        
        self.tappedMarker = GMSMarker()
        self.customInfoWindow = CustomInfoWindow().loadView()
        self.customInfoWindow?.delegate = self
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        self.clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        kCameraLatitude = userLocation.coordinate.latitude
        kCameraLongitude = userLocation.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 15)
        //slow down gmaps zoom in animation
        CATransaction.begin()
        CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
        mapView.animate(to: camera)
        CATransaction.commit()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func callSegueFromInfoWindow() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
        controller.id = (customInfoWindow?.id)!
        controller.institutionName = (customInfoWindow?.institusionName)!
        controller.achizitiiCount = (customInfoWindow?.achizitiiDirecteLabel.text)!
        controller.licitatiiCount = (customInfoWindow?.licitatiiLabel.text)!
        
        show(controller, sender: self)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
        
        if marker.userData is POIItem {
            DispatchQueue.main.async() {
                self.customInfoWindow.intitutionNameLabel.text = ""
                self.customInfoWindow.achizitiiDirecteLabel.text = ""
                self.customInfoWindow.licitatiiLabel.text = ""
            }
            let poi = marker.userData as! POIItem
            let id = poi.id
            api.getInstitutionSummary(id: id!) { (institutionSummary, _ response, error) -> Void in
                guard error == nil else {
                    print(error!)
                    return
                }
                self.institutionSummary = institutionSummary
                
                self.customInfoWindow?.institusionName = institutionSummary.nume
                
                DispatchQueue.main.async() {
                    self.customInfoWindow.intitutionNameLabel.text = institutionSummary.nume
                    self.customInfoWindow.intitutionNameLabel.adjustsFontSizeToFitWidth = true
                    self.customInfoWindow.intitutionNameLabel.minimumScaleFactor = 0.2
                    
                    self.customInfoWindow.achizitiiDirecteLabel.text = String(institutionSummary.nr_achizitii)
                    self.customInfoWindow.achizitiiDirecteLabel.adjustsFontSizeToFitWidth = true
                    self.customInfoWindow.achizitiiDirecteLabel.minimumScaleFactor = 0.2
                    
                    self.customInfoWindow.licitatiiLabel.text = String(institutionSummary.nr_licitatii)
                    self.customInfoWindow.licitatiiLabel.adjustsFontSizeToFitWidth = true
                    self.customInfoWindow.licitatiiLabel.minimumScaleFactor = 0.2
                }
            }
            
            //get position of tapped marker
            let position = marker.position
            mapView.animate(toLocation: position)
            let point = mapView.projection.point(for: position)
            let newPoint = mapView.projection.coordinate(for: point)
            let camera = GMSCameraUpdate.setTarget(newPoint)
            mapView.animate(with: camera)
            
            customInfoWindow?.id = id!
            customInfoWindow?.layer.cornerRadius = 8
            customInfoWindow?.center = mapView.projection.point(for: position)
            self.mapView.addSubview(customInfoWindow!)
            
        } else {
            self.customInfoWindow?.removeFromSuperview()
        }
        return false
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customInfoWindow?.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let position = tappedMarker?.position
        customInfoWindow?.center = mapView.projection.point(for: position!)
        customInfoWindow?.center.y -= 105
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return false
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    private func populateMap() {
        var contents = ""
        if let path = Bundle.main.path(forResource: "institutii_publice_pins_v0", ofType: "csv") {
            // use path
            do {
                print(path)
                contents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            } catch {
                
            }
        }
        let csv_data = csv(data: contents)
        for csv_item in csv_data where csv_item.count == 4 {
            let item = POIItem(position: CLLocationCoordinate2DMake(Double(csv_item[2])!, Double(csv_item[1])!), id: Int(csv_item[0])!)
            clusterManager.add(item)
        }
    }
}
