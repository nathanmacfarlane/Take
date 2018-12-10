import Firebase
import Foundation
import UIKit

protocol RouteFirestore: class {
    func fsLoadFirstImage(completion: @escaping (_ key: String?, _ image: UIImage?) -> Void)
    func fsLoadImages(completion: @escaping (_ images: [String: UIImage]) -> Void)
    func fsSaveAr(imageId: String, bgImage: UIImage, dgImage: UIImage)
    func fsLoadAR(completion: @escaping (_ ar: [String: [UIImage]]) -> Void)
}
