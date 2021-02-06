//
//  MapView.swift
//  Enroute
//
//  Created by Radu Dan on 06.02.2021.
//

import SwiftUI
import MapKit

// MARK: - MapView
struct MapView: UIViewRepresentable {
    let annotations: [MKAnnotation]
    
    @Binding var selection: MKAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        mkMapView.addAnnotations(annotations)
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = selection {
            uiView.setRegion(
                MKCoordinateRegion(
                    center: annotation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                ),
                animated: true
            )
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection)
    }
}

// MARK: - Coordinator
extension MapView {
    final class Coordinator: NSObject, MKMapViewDelegate {
        private static let mapViewIdentifier = "MapViewAnnotation"
        
        @Binding var selection: MKAnnotation?
        
        init(selection: Binding<MKAnnotation?>) {
            self._selection = selection
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MapView.Coordinator.mapViewIdentifier) ??
                MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapView.Coordinator.mapViewIdentifier)
            view.canShowCallout = true
            return view
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else {
                return
            }
            
            selection = annotation
        }
    }
}
