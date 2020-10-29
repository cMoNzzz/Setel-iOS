//
//  STLNetworkConfiguration.swift
//  Geofencing
//
//  Created by Lam Si Mon on 20-10-28.
//

import Foundation
import Network
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import UIKit

public enum NetworkType {
    case wifi
    case cellular
    case unknown
}

public final class STLNetworkConfiguration: NEHotspotConfiguration {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var specificSSID: String?

    public var networkType = NetworkType.unknown

    override public init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func connectWifi(ssid: String, password: String) {
        let hotspotConfig = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
        hotspotConfig.joinOnce = false

        NEHotspotConfigurationManager.shared.apply(hotspotConfig) { error in

            if let error = error as NSError? {
                let errorCode = NEHotspotConfigurationError(rawValue: error.code)
                self.handleConnectingError(errorCode: errorCode ?? .unknown)

            } else {
                if self.retrieveCurrentSSID() == ssid {
                    self.specificSSID = ssid
                    UIViewController.displayAlert("Success Connected to - \(ssid)")
                } else {
                    UIViewController.displayAlert("\(ssid) - Not found")
                }
            }
        }
    }

    public func retrieveCurrentSSID() -> String? {
        let interfaces = CNCopySupportedInterfaces() as? [String]
        let interface = interfaces?
            .compactMap { [weak self] in self?.retrieveInterfaceInfo(from: $0) }
            .first

        return interface
    }

    public func startMonitoringNetwork() {
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in

            switch path.status {
            case .satisfied:
                self.networkType = self.checkConnectionTypeForPath(path: path)
                print("Network satisfied \(self.networkType)")
            default:
                self.networkType = .unknown
            }
        }
    }

    public func stopMonitoringNetwork() {
        monitor.cancel()
    }

    public func getSpecificSSID() -> String {
        return specificSSID ?? ""
    }
}

extension STLNetworkConfiguration {
    private func retrieveInterfaceInfo(from interface: String) -> String? {
        guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject],
            let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
        else {
            return nil
        }
        return ssid
    }

    private func checkConnectionTypeForPath(path: Network.NWPath) -> NetworkType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }

        return .unknown
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
