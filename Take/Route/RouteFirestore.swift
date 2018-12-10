import Foundation
import UIKit

protocol RouteFirestore {
    func fsLoadImages(completion: @escaping (_ images: [String: UIImage]) -> Void)
    func fsLoadAR(completion: @escaping ([String: [UIImage]]) -> Void)
    func fsLoadFirstImage(completion: @escaping (_ key: String?, _ image: UIImage?) -> Void)
    func fsSaveAr(imageId: String, bgImage: UIImage, dgImage: UIImage)
}
