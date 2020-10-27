//
//  STLAddAnnotationProtocol.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-27.
//

import CoreLocation
import Foundation

public protocol STLAddAnnotationDelegate {
    func didAddAnnotation(_ controller: STLAddGeofenceViewController, coordinate: CLLocationCoordinate2D, radius: Double, identifier: String)
}
