final class CommandWith {
    private let action: () -> ()
    
    init(action: @escaping () -> ()) {
        self.action = action
    }
    
    func perform() {
        action()
    }
}
