//
//  ViewController.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-25.
//

import Combine
import MapKit
import UIKit

public final class STLMainViewController: UIViewController {
    let viewModel = STLLocationViewModel()

    private var disposeBag: Set<AnyCancellable> = []

    @IBOutlet var mapView: STLMapView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setup()
    }

    private func setup() {
        mapView.delegate = self

        viewModel.$status.receive(on: DispatchQueue.main).sink { status in

            if status == .authorizedAlways || status == .authorizedWhenInUse {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.mapView.zoomToUserLocation()
                }
            }
        }.store(in: &disposeBag)

        viewModel.$insideGeofenceRadius.receive(on: DispatchQueue.main).sink { inside in

            self.title = inside ? "Current Status: Inside" : "Current Status: Outside"

        }.store(in: &disposeBag)
    }

    @IBAction func onTapCurrentLocation(_: Any) {
        mapView.zoomToUserLocation()
    }

    @IBAction func onTapAddPin(_: Any) {
        if let vc = ControllerLoader.load(viewControllerType: STLAddGeofenceViewController.self) {
            let nc = UINavigationController(rootViewController: vc)
            vc.delegate = self
            nc.presentSelfOnTopMostViewController(animated: true, completion: nil)
        }
    }

    @IBAction func connectToSpecificNetwork(_: Any) {
        let loginController = UIAlertController.promptLogin { _ in
            // Handle cancel action
        } loginHandler: { _, ssid, password in
            self.viewModel.networkConfiguration.connectWifi(ssid: ssid, password: password)
        }
        present(loginController, animated: true, completion: nil)
    }
}

extension STLMainViewController: STLAddAnnotationDelegate {
    public func didAddAnnotation(_ controller: STLAddGeofenceViewController, coordinate: CLLocationCoordinate2D, radius: Double, identifier: String) {
        controller.dismiss(animated: true, completion: nil)

        let rad = min(radius, viewModel.locationManager.maximumRegionMonitoringDistance)
        let annotation = STLMapAnnotation(coordinate: coordinate, radius: rad, title: "Geofence Area", identifier: identifier)
        mapView.add(annotation: annotation)
        viewModel.startMonitoring(annotation: annotation)
    }
}

extension STLMainViewController: MKMapViewDelegate {
    public func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "STLAnnotation"
        if annotation is STLMapAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "delete-icon"), for: .normal)
                annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }

    public func mapView(_: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped _: UIControl) {
        if let annotation = view.annotation as? STLMapAnnotation {
            mapView.removeAnnotation(annotation)
        }
    }
}
