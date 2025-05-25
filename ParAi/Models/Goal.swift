import Foundation
import SwiftData

@Model
final class Goal {
    @Attribute(.unique) var id: UUID
    var title: String
    var targetAmount: Decimal
    var currentAmount: Decimal
    var deadline: Date

    init(
        id: UUID = UUID(),
        title: String,
        targetAmount: Decimal,
        currentAmount: Decimal = 0,
        deadline: Date
    ) {
        self.id = id
        self.title = title
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
    }
} 