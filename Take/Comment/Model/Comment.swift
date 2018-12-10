import CodableFirebase
import Firebase
import FirebaseFirestore
import Foundation
import UIKit

struct Comment: Codable {
    private var id: String
    private var userId: String
    private var dateString: String
    private var message: String?
    private var imageUrl: String?

    init(id: String, userId: String, dateString: String, message: String?, imageUrl: String?) {
        self.id = id
        self.userId = userId
        self.dateString = dateString
        self.message = message
        self.imageUrl = imageUrl
    }

    /* Getters */
    func getId() -> String {
        return id
    }
    func getUserId() -> String {
        return userId
    }
    func getDateString() -> String {
        return dateString
    }
    func getMessage() -> String? {
        return message
    }
    func getImageUrl() -> String? {
        return imageUrl
    }

    /* Setters */
    mutating func setImageUrl(imageUrl: String?) {
        self.imageUrl = imageUrl
    }
}

class CommentModelView {
    var comment: Comment!
    var id: String {
        return self.comment.getId()
    }
    var userId: String {
        return self.comment.getUserId()
    }
    var dateString: String {
        return self.comment.getDateString()
    }
    var message: String {
        return self.comment.getMessage() ?? "N/A"
    }
    var imageUrl: String? {
        return self.comment.getImageUrl()
    }

    init(comment: Comment) {
        self.comment = comment
    }
}
