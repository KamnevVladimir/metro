import UIKit
import SDWebImage

final class TwitterTableViewCell: UITableViewCell {
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var favoriteLabel: UILabel!
    @IBOutlet private weak var retweetsLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    var postTitle: String? {
        didSet {
            bodyLabel.text = postTitle
        }
    }
    
    var postImage: UIImage? {
        didSet {
            postImageView.image = postImage
            postImageView.isHidden = false
        }
    }
    
    var favoriteCount: String? {
        didSet {
            favoriteLabel.text = favoriteCount
        }
    }
    
    var retweetsCount: String? {
        didSet {
            retweetsLabel.text = retweetsCount
        }
    }
    
    var time: String? {
        didSet {
            timeLabel.text = time
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.twitterBackground
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.isHidden = true
    }
}
