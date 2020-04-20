//
//  AnnoattionsModel.swift
//  MapViewUIKit
//
//  Created by Lalith  on 20/04/20.
//  Copyright © 2020 Lalith . All rights reserved.
//

import Foundation
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
    var slope: Double!
    var isslope: Bool = false
}

class CoordinateAnnotation: MKPointAnnotation {
    var imageName: String!
}
