import Foundation
import UIKit

extension RoutePhotosViewController: CommentDelegate {

    func toggleCommentView() {
        isAddingComment = !isAddingComment
        self.heightConstraint.constant = isAddingComment ? 140 : 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    func addNewComment(comment: Comment, photo: UIImage) {
        let commentViewModel = CommentModelView(comment: comment)
        comments[commentViewModel.id] = commentViewModel
        images[commentViewModel.id] = photo
        commentKeys.insert(commentViewModel.id, at: 0)
        myImagesCV.reloadData()
    }
}
