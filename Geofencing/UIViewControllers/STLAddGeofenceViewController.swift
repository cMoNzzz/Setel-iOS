//
//  STLAddGeofenceViewController.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-27.
//

import Foundation
import MapKit
import UIKit

public final class STLAddGeofenceViewController: UIViewController {
    public var delegate: STLAddAnnotationDelegate?

    @IBOutlet var mapView: STLMapView!
    @IBOutlet var radiusTextField: UITextField!

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension STLAddGeofenceViewController {
    @IBAction func onZoomUserLocation(_: Any) {
        mapView.zoomToUserLocation()
    }

    @IBAction func onAddAnnotation(_: Any) {
        let coordinate = mapView.centerCoordinate
        let radius = Double(radiusTextField.text ?? "100") ?? 0
        let identifier = NSUUID().uuidString

        delegate?.didAddAnnotation(self, coordinate: coordinate, radius: radius, identifier: identifier)
    }

    @IBAction func onCancel(_: Any) {
        dismiss(animated: true, completion: nil)
    }
}
