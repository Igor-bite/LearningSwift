//
//  ViewController.swift
//  Project16
//
//  Created by Игорь Клюжев on 09.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(chooseMapType))
        
        let London = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let Oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "It was founded over a thousand years ago")
        let Paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: -2.3508), info: "Often called the City of Light")
        let Rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside")
        let Washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself")
        
        mapView.addAnnotations([London, Oslo, Rome, Washington, Paris])
    }
    
    @objc func chooseMapType() {
        let ac = UIAlertController(title: "Choose the type of map", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "SatelliteFlyover", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .satelliteFlyover
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "HybridFlyover", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .hybridFlyover
        }))
        ac.addAction(UIAlertAction(title: "MutedStandard", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .mutedStandard
        }))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .standard
        }))
        
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            annotationView?.pinTintColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        } else {
            annotationView?.annotation = annotation
            annotationView?.pinTintColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        var urlString = "https://en.wikipedia.org/wiki/\(placeName!)"
        
        if let url = URL(string: urlString) {
            let vc = DetailViewController()
            vc.urlToLoad = url
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

