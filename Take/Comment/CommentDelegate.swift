import Foundation
import UIKit

protocol CommentDelegate: class {
    func toggleCommentView()
    func addNewComment(comment: Comment, photo: UIImage)
}
