//
//  OtherAsync.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/9/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

func loadImageFrom(url: URL, completion: @escaping (_ image: UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let tempData = data else { return }
        guard let tempImage = UIImage(data: tempData) else { return }
        completion(tempImage)
    }
    .resume()
}
