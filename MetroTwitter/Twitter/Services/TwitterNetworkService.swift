import UIKit
import SwiftyJSON
import SDWebImage

protocol NetworkServiceDescription {
    func posts(completion: @escaping (Result<[TwitterPost], Error>) -> Void)
    func downloadImage(from urlString: String?) -> UIImage?
}

enum NetworkError: Error {
    case unexpected
    case wrongFormat
}

struct TwitterNetworkService: NetworkServiceDescription {
    static let shared = TwitterNetworkService()
        
        private init() {}

        func posts(completion: @escaping (Result<[TwitterPost], Error>) -> Void) {
            guard let url = URL(string: "https://devapp.mosmetro.ru/api/tweets/v1.0/") else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                let mainThreadCompletion: (Result<[TwitterPost], Error>) -> Void = { result in
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                
                if let error = error {
                    mainThreadCompletion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    mainThreadCompletion(.failure(NetworkError.unexpected))
                    return
                }
                
                do {
                    let json = try JSON(data: data)
                    let posts = formatingJson(from: json)
                    mainThreadCompletion(.success(posts))
                } catch {
                    mainThreadCompletion(.failure(error))
                }
            }.resume()
        }
    
    func downloadImage(from urlString: String?) -> UIImage? {
        guard let urlString = urlString else { return nil }
        let url = URL(string: urlString)
        let imageView = UIImageView()
        imageView.sd_setImage(with: url, completed: nil)
        return imageView.image
    }
    
    private func formatingJson(from json: JSON) -> [TwitterPost] {
        var posts: [TwitterPost] = []
        
        for index in 0..<json["data"].count {
            if let post = TwitterPost(json: json["data"][index]) {
                posts.append(post)
            }
        }
        return posts
    }
}
