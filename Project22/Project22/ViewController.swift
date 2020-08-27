//
//  ViewController.swift
//  Project22
//
//  Created by Игорь Клюжев on 16.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    @IBOutlet var beaconName: UILabel!
    
    @IBOutlet var locatorCircle: UIView!
    var isLocated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconName.text = ""
        
        locatorCircle.backgroundColor = .green
        locatorCircle.frame.size = CGSize(width: 256, height: 256)
        locatorCircle.layer.cornerRadius = 128
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuids = [UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, UUID(uuidString: "7C0FCF7D-4B24-43A9-A549-3BC988665036")!]
        let beaconRegion1 = CLBeaconRegion(uuid: uuids[0], major: 123, minor: 456, identifier: "MyBeacon1")
        let beaconRegion2 = CLBeaconRegion(uuid: uuids[1], major: 123, minor: 456, identifier: "MyBeacon2")
        
        locationManager?.startMonitoring(for: beaconRegion1)
        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(satisfying: beaconRegion1.beaconIdentityConstraint)
        locationManager?.startRangingBeacons(satisfying: beaconRegion2.beaconIdentityConstraint)
    }
    
    func foundBeacon() {
        let ac = UIAlertController(title: "Beacon found", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    func update(distance: CLProximity) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            switch distance {
            case .far:
                self?.view.backgroundColor = .blue
                self?.locatorCircle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self?.distanceReading.text = "FAR"
            
            case .near:
                self?.view.backgroundColor = .orange
                self?.locatorCircle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self?.distanceReading.text = "NEAR"
            
            case .immediate:
                self?.view.backgroundColor = .red
                self?.locatorCircle.transform = .identity
                self?.distanceReading.text = "RIGHT HERE"
            
            default:
                self?.view.backgroundColor = .gray
                self?.locatorCircle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self?.distanceReading.text = "UNKNOWN"
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            if !isLocated {
                foundBeacon()
                isLocated = true
            }
            update(distance: beacon.proximity)
            beaconName.text = beacon.uuid.uuidString
        } else {
            isLocated = false
            beaconName.text = ""
            update(distance: .unknown)
        }
    }
}

