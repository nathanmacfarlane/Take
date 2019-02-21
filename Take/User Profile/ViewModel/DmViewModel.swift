import CodableFirebase
import FirebaseFirestore
import Foundation
import Geofirestore
import MapKit
import UIKit

class DmViewModel {
    
    var dm: DM
    
    init(dm: DM) {
        self.dm = dm
    }
    
    var messageId: String {
        return dm.messageId
    }
    
    var userIds: [String] {
        return Array(dm.userIds)
    }
    
    var Thread: [ThreadContent] {
        return Array(dm.Thread)
    }

}
