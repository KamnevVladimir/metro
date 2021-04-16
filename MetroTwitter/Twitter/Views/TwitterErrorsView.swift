import UIKit

final class TwitterErrorsView: UIView {
    @IBOutlet private weak var errorButton: UIButton!
    @IBOutlet private weak var errorDescriptionLabel: UILabel!
    private var onReload: CommandWith?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("TwitterLoadingView called init?(coder:)")
    }
    
    private func configureView() {
      guard let view = loadViewFromNib(nibName: "TwitterErrorsView") else { return }
        view.frame = bounds
        addSubview(view)
        
        errorButton.layer.cornerRadius = 8
    }
    
    func update(with text: String, onReload: CommandWith) {
        self.onReload = onReload
        errorDescriptionLabel.text = text
    }
    
    @IBAction private func errorButtonTapped(_ sender: Any) {
        onReload?.perform()
    }
}
