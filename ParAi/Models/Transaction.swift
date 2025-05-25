import Foundation
import SwiftData

enum TransactionType: String, Codable {
    case income
    case expense
}

@Model
final class Transaction {
    @Attribute(.unique) var id: UUID
    var type: TransactionType
    var category: String
    var amount: Decimal
    var date: Date
    var note: String?
    var repeatIntervalDays: Int16
    var wantOrNeed: Bool?
    @Relationship(inverse: \User.transactions) var user: User?

    init(
        id: UUID = UUID(),
        type: TransactionType,
        category: String,
        amount: Decimal,
        date: Date,
        note: String? = nil,
        repeatIntervalDays: Int16 = 0,
        wantOrNeed: Bool? = nil,
        user: User? = nil
    ) {
        self.id = id
        self.type = type
        self.category = category
        self.amount = amount
        self.date = date
        self.note = note
        self.repeatIntervalDays = repeatIntervalDays
        self.wantOrNeed = wantOrNeed
        self.user = user
    }
} 