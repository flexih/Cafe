//
//  ViewController+MapKit.swift
//  coffee
//
//  Created by flexih on 1/9/16.
//  Copyright © 2016 flexih. All rights reserved.
//

import MapKit

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard !didUpdateUserLocation else {
            return
        }

        didUpdateUserLocation = true
        
        mapView.setRegion(MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)

        locateUser()
    }
    
    fileprivate struct Indentifier {
        static var annotationView = "annotationView"
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Indentifier.annotationView) {
            pinView.annotation = annotation
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Indentifier.annotationView)
            pinView.annotation = annotation
            pinView.pinColor = .green
            pinView.canShowCallout = true
            pinView.animatesDrop = false
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        navigationController?.pushViewController(CafeViewController(cafe: (view.annotation as! CafeAnnotation).cafe), animated: true)
    }
    
    func addAnnotations(_ cafes: [Cafe]) {
        removeAllAnnotations()
        
        mapView.addAnnotations(cafes.map{CafeAnnotation(cafe: $0)})
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
}
