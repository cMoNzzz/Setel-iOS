//
//  STLNetworkConfiguration.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-28.
//

import Foundation
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import UIKit

public final class STLNetworkConfiguration: NEHotspotConfiguration {
    public func connectWifi(ssid: String, password: String) {
        let hotspotConfig = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
        hotspotConfig.joinOnce = false

        NEHotspotConfigurationManager.shared.apply(hotspotConfig) { error in

            if let error = error as NSError? {
                let errorCode = NEHotspotConfigurationError(rawValue: error.code)
                self.handleConnectingError(errorCode: errorCode ?? .unknown)

            } else {
                if self.availableSSIDs().first == ssid {
                    UIViewController.displayAlert("Success Connected to - \(ssid)")
                } else {
                    UIViewController.displayAlert("\(ssid) - Not found")
                }
            }
        }
    }

    private func availableSSIDs() -> [String] {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        return interfaceNames.compactMap { name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: AnyObject] else {
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            return ssid
        }
    }

    private func handleConnectingError(errorCode: NEHotspotConfigurationError) {
        var errorMessage = ""

        switch errorCode {
        case .invalid:
            errorMessage = "Invalid"
        case .invalidSSID:
            errorMessage = "Invalid SSID"
        case .invalidWPAPassphrase, .invalidWEPPassphrase:
            errorMessage = "Invalid Password"
        case .userDenied:
            errorMessage = "Connection denied by user"
        case .unknown:
            errorMessage = "Unknown error"
        case .joinOnceNotSupported:
            errorMessage = "Join once not supported"
        default:
            errorMessage = "Connection already established"
        }

        UIViewController.displayAlert(errorMessage)
    }
}
