import Foundation
import UIKit

extension String {
    func getImage(completion: @escaping (_ image: UIImage?) -> Void) {
        guard let theURL = URL(string: self) else {
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
}
