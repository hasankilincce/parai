import Foundation
import SwiftData

@Model
final class UserSetting {
    @Attribute(.unique) var id: UUID
    var currency: String
    var aiModel: String

    init(
        id: UUID = UUID(),
        currency: String = "TRY",
        aiModel: String = "flash"
    ) {
        self.id = id
        self.currency = currency
        self.aiModel = aiModel
    }
} 