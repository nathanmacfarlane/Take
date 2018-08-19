//
//  OtherAsync.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/9/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

func loadImageFrom(url: String, completion: @escaping (_ image: UIImage) -> Void) {
    URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
        completion(UIImage(data: data!)!)
        }.resume()
}
