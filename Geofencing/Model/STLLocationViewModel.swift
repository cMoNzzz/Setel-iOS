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

public enum RegionState: Int {
    case enter
    case exit
    case none
}

public final class STLLocationViewModel: NSObject, ObservableObject {
    public var locationManager = CLLocationManager()

    @Published var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var status = CLAuthorizationStatus.notDetermined
    @Published var insideGeofenceRadius = false

    private var regionState = RegionState.none
    let networkConfiguration = STLNetworkConfiguration()

    override public init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    public func startMonitoring(annotation: STLMapAnnotation) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            UIViewController.displayAlert("Not supported")
            return
        }

        let newRegion = region(with: annotation)
        locationManager.startMonitoring(for: newRegion)
    }

    private func region(with annotation: STLMapAnnotation) -> CLCircularRegion {
        let region = CLCircularRegion(center: annotation.coordinate, radius: annotation.radius, identifier: annotation.identifier ?? "")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
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

    public func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        UIViewController.displayAlert("Location Failed with Error \(error)")
    }

    public func locationManager(_: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError _: Error) {
        guard let identifier = region?.identifier else { return }
        regionState = .none
        UIViewController.displayAlert("Monitoring failed with identifier \(identifier)")
    }

    public func locationManager(_: CLLocationManager, didEnterRegion _: CLRegion) {
        if regionState != .enter {
            regionState = .enter
            insideGeofenceRadius = true
        }
    }

    public func locationManager(_: CLLocationManager, didExitRegion _: CLRegion) {
        if regionState != .exit {
            regionState = .exit

            if networkConfiguration.networkType == .wifi {
                insideGeofenceRadius = networkConfiguration.retrieveCurrentSSID() == networkConfiguration.getSpecificSSID()
            } else {
                insideGeofenceRadius = false
            }
        }
    }
}
