import Foundation
import SwiftyJSON

struct TwitterPost {
    let text: String
    let time: Int
    let retweet: Int
    let favorite: Int
    let image: String?
    
    init?(json: JSON) {
        guard let text = json["text"].string,
              let time = json["createdAt"].int,
              let retweet = json["retweetCount"].int,
              let favorite = json["favoriteCount"].int
        else { return nil }
        self.text = text
        self.time = time
        self.retweet = retweet
        self.favorite = favorite
        if let image = json["mediaEntities"][0].string {
            self.image = image
        } else {
            image = nil
        }
        
    }
}
