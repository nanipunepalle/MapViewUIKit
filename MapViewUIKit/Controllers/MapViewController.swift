//
//  MapViewController.swift
//  MapViewUIKit
//
//  Created by Lalith  on 20/04/20.
//  Copyright © 2020 Lalith . All rights reserved.
//

import UIKit
import MapKit
//import MKMapView

class MapViewController: UIViewController {
    
    var sourecCity: String!
    var destinationCity: String!
    var intermediateCity: String?
    let locationManager = LocationManager()
    
    var sourceCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var destinationCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var intermediateCoordinates: CLLocationCoordinate2D?
    
    let sourceAnnotation = CoordinateAnnotation()
    let destinationAnnotation = CoordinateAnnotation()
    let intermediateAnnotation = CoordinateAnnotation()
    let movingAnnotaion = CustomPointAnnotation()
    let myGroup = DispatchGroup()
    let annotation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        mapView.delegate = self
        var noCities = 2
        var count = 0
        sourceAnnotation.imageName = "plane"
        destinationAnnotation.imageName = "plane"
        intermediateAnnotation.imageName = "plane"
        movingAnnotaion.imageName = "plane"
        if intermediateCity != ""{
            noCities = 3
        }
        mapView.addAnnotations([sourceAnnotation,destinationAnnotation,intermediateAnnotation,movingAnnotaion])
        myGroup.enter()
        self.locationManager.getCoordinate(addressString: self.sourecCity) { (coordinate, error) in
            if error != nil {
                print(error ?? "error")
            }
            else{
                self.sourceCoordinates = coordinate
                count += 1
                self.check(count: count, noCities: noCities)
            }
            
        }
        
        self.locationManager.getCoordinate(addressString: self.destinationCity) { (coordinate, error) in
            if error != nil {
                print(error ?? "error")
            }
            else{
                self.destinationCoordinates = coordinate
                count += 1
                self.check(count: count, noCities: noCities)
            }
        }
        
        if intermediateCity != ""{
            self.locationManager.getCoordinate(addressString: self.intermediateCity!) { (coordinate, error) in
                if error != nil {
                    print(error ?? "error")
                }
                else{
                    self.intermediateCoordinates = coordinate
                    count += 1
                    self.check(count: count, noCities: noCities)
                }
            }
        }
        
        myGroup.notify(queue: DispatchQueue.main) {
            
            self.annotation.coordinate = self.sourceCoordinates
            self.sourceAnnotation.coordinate = self.sourceCoordinates
            self.destinationAnnotation.coordinate = self.destinationCoordinates
            
            if self.intermediateCoordinates != nil{
                let iSlope = self.findSlope(sCoord: self.sourceCoordinates, dcord: self.intermediateCoordinates!)
                let dSlope = self.findSlope(sCoord: self.intermediateCoordinates!, dcord: self.destinationCoordinates)
                self.intermediateAnnotation.coordinate = self.intermediateCoordinates!
                let routeLine1 = MKPolyline(coordinates: [self.sourceCoordinates,self.intermediateCoordinates!,self.destinationCoordinates], count: 3)
                self.mapView.setRegion(MKCoordinateRegion(routeLine1.boundingMapRect), animated: true)
                self.mapView.addOverlay(routeLine1)
                self.mapView.setRegion(MKCoordinateRegion(routeLine1.boundingMapRect), animated: true)
                self.animation1(iSlope: iSlope, dSlope: dSlope, uiView: self.mapView)
            }
            else if self.intermediateCoordinates == nil{
                self.checkCoordinates(sourceCoordinates: self.sourceCoordinates, destinationCoordinates: self.destinationCoordinates)
                let slope = self.findSlope(sCoord: self.sourceCoordinates,dcord: self.destinationCoordinates)
                self.movingAnnotaion.slope = slope
                let routeLine1 = MKPolyline(coordinates: [self.sourceCoordinates,self.destinationCoordinates], count: 2)
                self.mapView.setRegion(MKCoordinateRegion(routeLine1.boundingMapRect), animated: true)
                self.mapView.addOverlay(routeLine1)
                self.mapView.setRegion(MKCoordinateRegion(routeLine1.boundingMapRect), animated: true)
                self.animation2()
            }
        }
        
        
    }
    
}


extension UIImage{
    func resizedImage(newSize: CGSize) -> UIImage {
        guard self.size != newSize else { return self }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension MapViewController{
    
    //Animation if there is intermediate stop
    
    func check(count: Int,noCities: Int){
        if count == noCities{
            myGroup.leave()
        }
    }
    
    
    //Functions to point the annottaion according to route by finding slope of the route and checking latitudes and longitudes
    func findSlope(sCoord: CLLocationCoordinate2D,dcord: CLLocationCoordinate2D) -> Double{
        let slope = (dcord.longitude - sCoord.longitude)/(dcord.latitude - sCoord.latitude)
        return slope
    }
    func checkCoordinates(sourceCoordinates: CLLocationCoordinate2D,destinationCoordinates: CLLocationCoordinate2D){
        if sourceCoordinates.latitude > destinationCoordinates.latitude{
            self.movingAnnotaion.isslope = true
        }
        else{
            self.movingAnnotaion.isslope = false
        }
    }
    
    //Update the animating annotation
    func updateMovingAnnotation(slope: Double,uiView: MKMapView){
        uiView.removeAnnotation(self.movingAnnotaion)
        uiView.addAnnotation(self.movingAnnotaion)
        self.movingAnnotaion.slope = slope
    }
}
