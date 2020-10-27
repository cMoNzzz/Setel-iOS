//
//  STLCurrentLocationModel.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-26.
//

import Combine
import CoreLocation
import Foundation
import UIKit

public class STLLocationViewModel: NSObject, ObservableObject {
    public var locationManager = CLLocationManager()

    @Published var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var status = CLAuthorizationStatus.notDetermined

    override public init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension STLLocationViewModel: CLLocationManagerDelegate {
    public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinate = location.coordinate
    }

    public func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    public func locationManager(_: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError _: Error) {
        guard let identifier = region?.identifier else { return }

        UIViewController.displayAlert("Monitoring failed with identifier \(identifier)")
    }

    public func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        UIViewController.displayAlert("Location Failed with Error \(error)")
    }
}
