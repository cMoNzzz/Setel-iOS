//
//  STLMapAnnotation.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-26.
//

import Foundation
import MapKit

public class STLMapAnnotation: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public var radius: CLLocationDistance
    public var identifier: String?
    public var title: String?

    public init(coordinate: CLLocationCoordinate2D,
                radius: CLLocationDistance,
                title: String,
                identifier: String)
    {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.title = title
    }
}
