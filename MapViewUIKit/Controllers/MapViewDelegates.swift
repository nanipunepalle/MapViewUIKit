//
//  MapViewDelegates.swift
//  MapViewUIKit
//
//  Created by Lalith  on 20/04/20.
//  Copyright © 2020 Lalith . All rights reserved.
//

import Foundation
import UIKit
import MapKit

//extension MapViewController: MKMap
extension MapViewController: MKMapViewDelegate{
    
    //Delegate for customization of annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "view")
        annotationView.canShowCallout = false
        var radians: Double
        var editedimage: UIImage
        if let coordinateAnnotation = annotation as? CoordinateAnnotation {
            let image = UIImage(named: coordinateAnnotation.imageName)
            editedimage = image!.resizedImage(newSize: CGSize(width: 40, height: 40))
            annotationView.image = editedimage
        }
        if let animationAnnotation = annotation as? CustomPointAnnotation {
            let image = UIImage(named: animationAnnotation.imageName)
            let degrees = atan(animationAnnotation.slope) * 180/Double.pi
            let sizedImage = image!.resizedImage(newSize: CGSize(width: 60, height: 60))
            annotationView.image = sizedImage
            radians = animationAnnotation.isslope ? (degrees * Double.pi/180) + Double.pi : (degrees * Double.pi/180)
            annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(radians))
        }
        return annotationView
    }
    
    //Delegate for overlay of polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .red
        render.lineWidth = 3
        render.lineDashPhase = 2
        render.lineDashPattern = [1,5]
        return render
    }
}
