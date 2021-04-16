import UIKit

protocol TwitterViewOutput: AnyObject {
    func loadImage(from urlString: String?) -> UIImage?
    func formatTime(from time: Int) -> String
}

final class TwitterView: UIView {
    unowned var output: TwitterViewOutput
    
    enum Props {
        case initial
        case loading
        case error(Error)
        case loaded([Post])
        
        struct Post {
            let content: TwitterPost
            let onSelect: CommandWith
        }
        
        struct Error {
            let text: String
            let onReload: CommandWith
        }
    }
    
    var props: Props = Props.initial {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var twitterLoadingView: TwitterLoadingView = {
        let view = TwitterLoadingView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var twitterErrorsView: TwitterErrorsView = {
        let view = TwitterErrorsView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var twitterTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.twitterBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TwitterStaticTableViewCell.nib, forCellReuseIdentifier: TwitterStaticTableViewCell.identifier)
        tableView.register(TwitterTableViewCell.nib, forCellReuseIdentifier: TwitterTableViewCell.identifier)
        return tableView
    }()
    
    init(frame: CGRect, output: TwitterViewOutput) {
        self.output = output
        super.init(frame: frame)
        configureViews()
        configureLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch props {
        case .loading:
            twitterErrorsView.isHidden = true
            twitterLoadingView.isHidden = false
            twitterTableView.isHidden = true
            twitterLoadingView.startAnimating()
        case .error(let error):
            twitterLoadingView.stopAnimating()
            twitterErrorsView.isHidden = false
            twitterLoadingView.isHidden = true
            twitterTableView.isHidden = true
            twitterErrorsView.update(with: error.text, onReload: error.onReload)
        case .loaded:
            twitterLoadingView.stopAnimating()
            twitterErrorsView.isHidden = true
            twitterLoadingView.isHidden = true
            twitterTableView.isHidden = false
            twitterTableView.reloadData()
        default:
            twitterLoadingView.stopAnimating()
            twitterErrorsView.isHidden = true
            twitterLoadingView.isHidden = true
            twitterTableView.isHidden = true
        }
    }
    
    private func configureViews() {
        guard let view = loadViewFromNib(nibName: "TwitterView") else { return }
        view.frame = frame
        addSubview(view)
        
        view.addSubviews(twitterTableView,
                         twitterLoadingView,
                         twitterErrorsView)
    }
    
    private func configureLayouts() {
        let marginHorizontal: CGFloat = 20
        
        let constraints = [
            twitterLoadingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            twitterLoadingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: marginHorizontal),
            twitterLoadingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -marginHorizontal),
            twitterLoadingView.heightAnchor.constraint(equalToConstant: 211),
            
            twitterErrorsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            twitterErrorsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: marginHorizontal),
            twitterErrorsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -marginHorizontal),
            twitterErrorsView.heightAnchor.constraint(equalToConstant: 258),
            
            twitterTableView.topAnchor.constraint(equalTo: topAnchor),
            twitterTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            twitterTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            twitterTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
//MARK: - UITableViewDelegate
extension TwitterView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .loaded(let posts) = props {
            posts[indexPath.row].onSelect.perform()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - UITableViewDataSource
extension TwitterView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .loaded(let posts) = props {
            switch section {
            case 0:
                return 1
            case 1:
                return posts.count
            default:
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case .loaded(let posts) = props {
            switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TwitterStaticTableViewCell.identifier) as? TwitterStaticTableViewCell else { return UITableViewCell() }
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TwitterTableViewCell.identifier) as? TwitterTableViewCell else { return UITableViewCell() }
                
                let post = posts[indexPath.row].content
                cell.postTitle = post.text
                cell.retweetsCount = String(post.retweet)
                cell.favoriteCount = String(post.favorite)
                cell.time = output.formatTime(from: post.time)
                guard let image = output.loadImage(from: post.image) else { return cell }
                cell.postImage = image
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
}
