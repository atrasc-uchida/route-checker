//
//  ViewController.swift
//  route-checker
//
//  Created by Harunori Uchida on 2020/09/17.
//  Copyright © 2020 atrasc.co.jp. All rights reserved.
//

import UIKit
import MapKit;
import IBAnimatable;

class ViewController: UIViewController {

	@IBOutlet weak var button: AnimatableButton!
	@IBOutlet weak var mapView: MKMapView!
	
	private var locationManager:CLLocationManager?;
	
	private var locations:[CLLocation] = [];
	private var coordinates:[CLLocationCoordinate2D] = [];
	private var isRecording:Bool = false;
	private var polyLines:[MKPolyline] = [];
	
	internal
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.startUpdatingLocation()
        }
        // tracking user location
		mapView.showsCompass = true;
		mapView.userTrackingMode = .follow;
        mapView.showsUserLocation = true
		mapView.zoomLevel = 19;
		mapView.delegate = self;
		
		
		self.button.addTarget(self, action: #selector(self.onButtonTap), for: .touchUpInside);
		self.button.backgroundColor = .white;
		self.button.setTitleColor(.red, for: .normal);
		self.button.borderColor = .red;
		
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
		let location = touch.location(in: self.view) //in: には対象となるビューを入れます
		self.update(location);

	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
		let location = touch.location(in: self.view) //in: には対象となるビューを入れます
		
		event?.coalescedTouches(for: touch);
		self.update(location);
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
				let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
		let location = touch.location(in: self.view) //in: には対象となるビューを入れます
		self.update(location);

	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
				let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
		let location = touch.location(in: self.view) //in: には対象となるビューを入れます
		self.update(location);

		if (self.isRecording) {
			self.updateLine();
		}
	}
	
	func update(_ location:CGPoint) {
		if (!self.isRecording) {return;}
		
		var coord = self.mapView.convert(location, toCoordinateFrom: self.view);
		self.coordinates.append(coord);
		print(self.coordinates.count);
		return;
		
	}
	
	func updateLine() {
		let polyLine = MKPolyline(coordinates:self.coordinates , count: self.coordinates.count);
//		let polyLine = MKPolyline(coordinates:self.locations.map{$0.coordinate} , count: self.locations.count);
		self.mapView.removeOverlays(self.mapView.overlays);
		self.mapView.addOverlay(polyLine);
	}
	
	
	
	@objc func onButtonTap() {
		if (!self.isRecording) {
			self.start();
		}else{
			self.stop();
		}
	}
	
	private func start() {
		if (self.isRecording) { return; }
		self.isRecording = true;
		
		mapView.isUserInteractionEnabled = false;
		self.locations = [];
		self.coordinates = [];
		self.updateLine();
		
		self.button.backgroundColor = .red;
		self.button.setTitleColor(.white, for: .normal);
		self.button.borderColor = .white;
		
		self.mapView.userTrackingMode = .none;
	}
	
	private func stop() {
		if (!self.isRecording)  { return; }
		self.isRecording = false;
		
		mapView.isUserInteractionEnabled = true;
		self.button.backgroundColor = .white;
		self.button.setTitleColor(.red, for: .normal);
		self.button.borderColor = .red;
		self.mapView.userTrackingMode = .follow;
	}
	
	

}

extension ViewController:MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let polyline = overlay as? MKPolyline {
			let polylineRenderer = MKPolylineRenderer(polyline: polyline)
			polylineRenderer.strokeColor = .blue
			polylineRenderer.lineWidth = 2.0
			return polylineRenderer
		}
		return MKOverlayRenderer()
	}
}

extension ViewController:CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		 switch status {
		 case .notDetermined:
			 manager.requestWhenInUseAuthorization()
		 case .restricted, .denied:
			 break
		 case .authorizedAlways, .authorizedWhenInUse:
			 break
		@unknown default:
			fatalError()
		}
	 }
	 
	 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		mapView.userTrackingMode = .follow
		 guard let newLocation = locations.last else {
			 return
		 }
		
//		if (self.isRecording) {
//			self.locations += locations;
//
//
//			var coordinateInput:[CLLocationCoordinate2D] = ;
//
////			if (self.polyLines.count > 1) {
////				self.mapView.removeOverlay(self.polyLines.remove(at: 0));
////			}
//
//			if (self.polyLines.count == 0) {
//
//			}else{
//				self.mapView.exchangeOverlay(self.polyLines.first!, with: polyLine);
//
//				self.polyLines.remove(at: 0);
//			}
//			self.polyLines.append(polyLine);
//
//			DispatchQueue.main.async {
//			}
//		}
		
//		let location:CLLocationCoordinate2D
//		   = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//		var region:MKCoordinateRegion = mapView.region
//        region.center = location
//		mapView.setRegion(region,animated:true);
		
//		 let latitude = "".appendingFormat("%.4f", location.latitude)
//		 let longitude = "".appendingFormat("%.4f", location.longitude)
//		 latLabel.text = "latitude: " + latitude
//		 lngLabel.text = "longitude: " + longitude
		 
		 // update annotation
//		 mapView.removeAnnotations(mapView.annotations)
//
//		 let annotation = MKPointAnnotation()
//		 annotation.coordinate = newLocation.coordinate
//		 mapView.addAnnotation(annotation)
//		 mapView.selectAnnotation(annotation, animated: true)
//
//		 // Showing annotation zooms the map automatically.
//		mapView.showAnnotations(mapView.annotations, animated: true);
//		mapView.zoomLevel = 14;
		 
	 }
}


extension MKMapView {

    var zoomLevel: Int {
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1);
        }

        set (newZoomLevel){
            setCenterCoordinate(coordinate:self.centerCoordinate, zoomLevel: newZoomLevel, animated: false)
        }
    }

    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
    }
}
