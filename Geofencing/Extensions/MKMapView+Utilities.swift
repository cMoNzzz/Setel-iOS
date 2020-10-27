//
//  Utilities.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-26.
//

import UIKit
import MapKit

extension MKMapView {
  public func zoomToUserLocation() {
    guard let coordinate = userLocation.location?.coordinate else { return }
    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
    setRegion(region, animated: true)
  }
}
