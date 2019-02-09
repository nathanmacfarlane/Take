import Foundation
import MapKit
import UIKit

class AreaViewModel {

    var area: Area
    var id: String {
        return area.id
    }
    var name: String {
        return area.name
    }
    var location: CLLocation {
        return CLLocation(latitude: area.latitude, longitude: area.longitude)
    }

    func getImage(completion: @escaping (_ image: UIImage?) -> Void) {
        guard let imageUrl = self.area.imageUrl, let theURL = URL(string: imageUrl) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: theURL) { data, _, _ in
            guard let theData = data, let theImage = UIImage(data: theData) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(theImage)
            }
        }
        .resume()
    }

    init(area: Area) {
        self.area = area
    }

}
