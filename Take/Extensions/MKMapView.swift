//
//  MKMapView.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/6/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func removeAllAnnotations() {
        self.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.removeAnnotation($0)
            }
        }
    }
    func removeAllOverlays() {
        self.removeOverlays(self.overlays)
    }
    func visibleDistance() -> Double {
        let span = self.region.span
        let center = self.region.center
        let loc1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
        let loc2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        let loc3 = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
        let loc4 = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)

        let metersInLatitude = loc1.distance(from: loc2)
        let metersInLongitude = loc3.distance(from: loc4)
        return metersInLatitude < metersInLongitude ? metersInLatitude : metersInLongitude
    }
    func centerMapOn(_ location: CLLocation, withRadius radius: Double = 3000) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
        self.setRegion(coordinateRegion, animated: true)
    }
    func addCircle(name: String, coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) -> AreaOverlay {
        let circle = AreaOverlay(center: coordinate, radius: radius)
        circle.area = Area(name: name, radius: radius, latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.add(circle)
        return circle
    }
}
