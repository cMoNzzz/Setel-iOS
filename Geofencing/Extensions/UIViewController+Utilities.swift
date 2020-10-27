//
//  UIViewController+Utilities.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-27.
//

import UIKit

extension UIViewController {

    public static func topMostViewController() -> UIViewController? {
        return UIApplication
            .shared
            .windows
            .filter { $0.isKeyWindow }
            .first?
            .rootViewController?
            .topMostViewController()
    }

    public static func displayAlert(title: String = "", _ message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        alertController.presentSelfOnTopMostViewController(animated: true, completion: nil)
    }
    
    public func presentSelfOnTopMostViewController(animated: Bool, completion: (() -> Void)?) {
        if let _ = UIViewController.topMostViewController() as? UIAlertController {
            UIViewController.topMostViewController()?.dismiss(animated: true, completion: {
                self.presentSelfOnTopMostViewController(animated: true, completion: nil)
            })
            return
        }
        
        DispatchQueue.main.async {
            UIViewController.topMostViewController()?.present(self, animated: animated, completion: completion)
        }
    }
    
    public func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        return self
    }
    
}

