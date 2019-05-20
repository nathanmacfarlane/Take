import Foundation
import GoogleMaps

class TakeGoogleMapView: GMSMapView {
    var markers: [GMSMarker] = []
    func removeMarkers() {
        for m in markers {
            m.map = nil
        }
    }
}
