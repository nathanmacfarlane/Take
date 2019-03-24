import Foundation
import UIKit

class ImageCache {

    static let shared = ImageCache()
    var cache: [String: UIImage] = [:]

    func addImage(url: String, image: UIImage) {
        cache[url] = image
    }

    func getImage(for url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let image = self.cache[url] {
                completion(image)
                return
            }
            url.getImage { image in
                completion(image)
                if let image = image {
                    self.cache[url] = image
                }
                return
            }
        }
    }

    func clearCache() {
        cache = [:]
    }
}
