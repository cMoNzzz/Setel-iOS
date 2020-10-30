//
//  STLMapView.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-29.
//

import Foundation
import MapKit
import UIKit

public final class STLMapView: MKMapView {
    public func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        setRegion(region, animated: true)
    }

    public func add(annotation: STLMapAnnotation) {
        addAnnotation(annotation)
        addRadiusOverlay(for: annotation)
    }

    private func addRadiusOverlay(for annotation: STLMapAnnotation) {
        addOverlay(MKCircle(center: annotation.coordinate, radius: annotation.radius))
    }

    private func removeAnnotation(for annotation: STLMapAnnotation) {
        removeAnnotation(annotation)

        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == annotation.coordinate.latitude,
                coord.longitude == annotation.coordinate.longitude,
                circleOverlay.radius == annotation.radius
            {
                removeOverlay(circleOverlay)
                break
            }
        }
    }
}
