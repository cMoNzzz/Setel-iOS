//
//  Ultilities.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-27.
//

import Foundation
import UIKit

public class ControllerLoader {
    public static func load<T>(viewControllerType _: T.Type) -> T? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
        return vc
    }
}
