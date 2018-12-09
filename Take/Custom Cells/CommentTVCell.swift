import UIKit

class CommentTVCell: UITableViewCell {
    var userImage: UIImageView!
    var nameLabel: UILabel!
    var commentLabel: UILabel!

    func initCell(username: String, comment: String, image: UIImage) {
        // user image view
        userImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        userImage.image = image
        userImage.roundView(portion: 2)
        userImage.addBorder(color: UIColor(hexString: "#2A313B"), width: 2)
        self.addSubview(userImage)
    }
}
