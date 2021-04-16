import Foundation
import SwiftDate

protocol DateServiceDescription {
    func formatTime(from: Int) -> String
}

final class TwitterDateService {
    static let shared = TwitterDateService()
    
    private init() {}
}

extension TwitterDateService: DateServiceDescription {
    func formatTime(from time: Int) -> String {
        let date = Date(milliseconds: time, region: .current)
        // Временной интервал от текущей даты до указанной
        var defInterval = Int(date.distance(to: Date()))
        var prefixString = ""
        switch time {
        case 0...59:
            prefixString = "секунд"
        case 60...3599:
            prefixString = "минут"
            defInterval /= 60
        case 3600...86399:
            prefixString = "часов"
            defInterval /= 3600
        default:
            prefixString = "дней"
            defInterval /= 86400
        }
        return String(defInterval) + " " + prefixString + " " + "назад"
    }
}


