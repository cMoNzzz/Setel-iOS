//
//  STLCurrentLocationModel.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-26.
//

import Foundation
import Combine
import CoreLocation
import UIKit

public class STLLocationViewModel:NSObject, ObservableObject {
    
    private var locationManager = CLLocationManager()
    
    @Published var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var status: CLAuthorizationStatus = CLAuthorizationStatus.notDetermined
    
    override public init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
}

extension STLLocationViewModel: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        coordinate = location.coordinate
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        guard let identifier = region?.identifier else { return }
        
        UIViewController.displayAlert("Monitoring failed with identifier \(identifier)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        UIViewController.displayAlert("Location Failed with Error \(error)")
    }
}
