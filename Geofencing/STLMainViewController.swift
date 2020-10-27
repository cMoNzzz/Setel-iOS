//
//  ViewController.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-25.
//

import UIKit
import Combine
import MapKit

class STLMainViewController: UIViewController {

    let locationViewModel = STLLocationViewModel()
    private var disposeBag: Set<AnyCancellable> = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    private func setup() {
        
        locationViewModel.$coordinate.receive(on: DispatchQueue.main).sink { coordinate in
            print("Coor 2 \(coordinate)")
        }.store(in: &disposeBag)
        
        locationViewModel.$status.receive(on: DispatchQueue.main).sink { status in
            
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
    
    @IBAction func onTapCurrentLocation(_ sender: Any) {
        zoomToUserLocation()
    }
    
}

