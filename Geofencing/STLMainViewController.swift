//
//  ViewController.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-25.
//

import UIKit
import Combine

class ViewController: UIViewController {

    let locationViewModel = STLLocationViewModel()
    private var disposeBag: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        locationViewModel.$coordinate.receive(on: DispatchQueue.main).sink { coordinate in
            print("Coor 2 \(coordinate)")
        }.store(in: &disposeBag)
    }


}

