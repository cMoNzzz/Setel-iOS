//
//  UIViewController+Login.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-28.
//

import UIKit

internal extension UIAlertController {
    static func promptLogin(dismissHandler: ((UIAlertController) -> Void)?, loginHandler: ((_ alertController: UIAlertController, _ ssid: String, _ password: String) -> Void)?) -> UIAlertController {
        var ssidTextField: UITextField?
        var passwordTextField: UITextField?

        let alertController = UIAlertController(title: "Wi-Fi", message: "Enter SSID and Password", preferredStyle: .alert)

        alertController.addTextField { ssidTF in
            ssidTextField = ssidTF
            ssidTextField?.placeholder = "Enter Wi-Fi SSID"
        }

        alertController.addTextField { passwordTF in
            passwordTextField = passwordTF
            passwordTextField?.placeholder = "Enter Wi-Fi Password"
            passwordTextField?.isSecureTextEntry = true
        }

        let loginAction = UIAlertAction(title: "Connect", style: .default, handler: { _ in

            if let ssid = ssidTextField?.text, let password = passwordTextField?.text {
                loginHandler?(alertController, ssid, password)
            } else {
                dismissHandler?(alertController)
            }
        })

        let dismissAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in

            dismissHandler?(alertController)

        })

        alertController.addAction(loginAction)
        alertController.addAction(dismissAction)

        return alertController
    }
}
