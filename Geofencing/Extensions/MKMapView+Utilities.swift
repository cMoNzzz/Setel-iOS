//
//  Utilities.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-26.
//

import MapKit

extension MKMapView {
    public func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        setRegion(region, animated: true)
    }
}
