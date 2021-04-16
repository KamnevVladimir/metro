import UIKit

final class TwitterLoadingView: UIView {
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("TwitterLoadingView called init?(coder:)")
    }
    
    private func configureView() {
        guard let view = loadViewFromNib(nibName: "TwitterLoadingView") else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
