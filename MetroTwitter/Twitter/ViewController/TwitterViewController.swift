import UIKit

final class TwitterViewController: UIViewController {
    private var networkService: NetworkServiceDescription = TwitterNetworkService.shared
    private var dateService: DateServiceDescription = TwitterDateService.shared
    
    override func loadView() {
        view = TwitterView(frame: UIScreen.main.bounds, output: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        updateView(with: .loading)
        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func updateView(with props: TwitterView.Props) {
        if let customView = view as? TwitterView {
            customView.props = props
        }
    }
    
    private func loadPosts() {
        networkService.posts { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                let textError = error.localizedDescription
                let command = CommandWith { [weak self] in
                    guard let self = self else { return }
                    self.loadPosts()
                }
                
                self.updateView(with: .error(.init(text: textError, onReload: command)))
                
            case .success(let posts):
                let propsPost = posts.map { post in
                    return TwitterView.Props.Post(content: post, onSelect: .init {
                        print(post.text)
                    })
                }
                
                self.updateView(with: .loaded(propsPost))
            }
        }
    }
}

extension TwitterViewController: TwitterViewOutput {
    
    func loadImage(from urlString: String?) -> UIImage? {
        return networkService.downloadImage(from: urlString)
    }
    
    func formatTime(from time: Int) -> String {
        return dateService.formatTime(from: time)
    }
}
