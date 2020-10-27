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

    @IBOutlet var mapView: MKMapView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setup()
    }

    private func setup() {
        mapView.delegate = self

        viewModel.$coordinate.receive(on: DispatchQueue.main).sink { coordinate in
            print("Coor 2 \(coordinate)")
        }.store(in: &disposeBag)

        viewModel.$status.receive(on: DispatchQueue.main).sink { status in

            if status == .authorizedAlways || status == .authorizedWhenInUse {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.zoomToUserLocation()
                }
            }
        }.store(in: &disposeBag)
    }

    private func zoomToUserLocation() {
        mapView.zoomToUserLocation()
    }

    @IBAction func onTapCurrentLocation(_: Any) {
        zoomToUserLocation()
    }

    @IBAction func onTapAddPin(_: Any) {
        if let vc = ControllerLoader.load(viewControllerType: STLAddGeofenceViewController.self) {
            let nc = UINavigationController(rootViewController: vc)
            vc.delegate = self
            nc.presentSelfOnTopMostViewController(animated: true, completion: nil)
        }
    }

    private func addAnnotation(_ annotation: STLMapAnnotation) {
        mapView.addAnnotation(annotation)
        addRadiusOverlay(forAnnotation: annotation)
    }

    private func addRadiusOverlay(forAnnotation annotation: STLMapAnnotation) {
        mapView?.addOverlay(MKCircle(center: annotation.coordinate, radius: annotation.radius))
    }
}

extension STLMainViewController: STLAddAnnotationDelegate {
    public func didAddAnnotation(_ controller: STLAddGeofenceViewController, coordinate: CLLocationCoordinate2D, radius: Double, identifier: String) {
        controller.dismiss(animated: true, completion: nil)

        let rad = min(radius, viewModel.locationManager.maximumRegionMonitoringDistance)
        let annotation = STLMapAnnotation(coordinate: coordinate, radius: rad, identifier: identifier)
        addAnnotation(annotation)
        print("Radius \(coordinate)")
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
}
