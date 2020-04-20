//
//  Animations.swift
//  MapViewUIKit
//
//  Created by Lalith  on 20/04/20.
//  Copyright © 2020 Lalith . All rights reserved.
//

import Foundation
import MapKit


extension MapViewController{
    
    //Animation if there is intermediate 
    func animation1(iSlope: Double,dSlope: Double,uiView: MKMapView){
        updateMovingAnnotation(slope: iSlope, uiView: uiView)
        self.checkCoordinates(sourceCoordinates: self.sourceCoordinates, destinationCoordinates: self.intermediateCoordinates!)
        UIView.animate(withDuration: 1,animations: {
            self.movingAnnotaion.coordinate = self.sourceCoordinates
        }) { done in
            if done{
                UIView.animate(withDuration: 30, animations: {
                    self.movingAnnotaion.coordinate = self.intermediateCoordinates!
                }) { suceess in
                    if suceess{
                        self.updateMovingAnnotation(slope: dSlope, uiView: uiView)
                        self.checkCoordinates(sourceCoordinates: self.intermediateCoordinates!, destinationCoordinates: self.destinationCoordinates)
                        UIView.animate(withDuration: 1, animations: {
                            self.movingAnnotaion.coordinate = self.intermediateCoordinates!
                        }) { complete in
                            if complete{
                                UIView.animate(withDuration: 30, animations: {
                                    self.movingAnnotaion.coordinate = self.destinationCoordinates
                                }) { (success) in
                                    self.animation1(iSlope: iSlope,dSlope: dSlope, uiView: uiView)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    //Animation if there is no intermediatestop
    func animation2(){
        UIView.animate(withDuration: 1, animations: {
            self.movingAnnotaion.coordinate = self.sourceCoordinates
        }) { success in
            if success{
                UIView.animate(withDuration: 30, animations: {
                    self.movingAnnotaion.coordinate = self.destinationCoordinates
                }) { done in
                    if done{
                        self.animation2()
                    }
                }
            }
        }
    }
}
