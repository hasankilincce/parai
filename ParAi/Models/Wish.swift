import Foundation
import SwiftData

@Model
final class Wish {
    @Attribute(.unique) var id: UUID
    var title: String
    var estimatedCost: Decimal
    var isApproved: Bool

    init(
        id: UUID = UUID(),
        title: String,
        estimatedCost: Decimal,
        isApproved: Bool = false
    ) {
        self.id = id
        self.title = title
        self.estimatedCost = estimatedCost
        self.isApproved = isApproved
    }
} 