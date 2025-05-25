import SwiftUI
import SwiftData

struct HomeView: View {
    // Örnek veriler (gerçek veriyle ViewModel üzerinden bağlanmalı)
    let userName: String = "Hasan"
    let currency: String = "₺"
    let goals: [Goal] = [
        Goal(title: "Tatil", targetAmount: 20000, currentAmount: 5000, deadline: Date().addingTimeInterval(60*60*24*200))
    ]
    let wishes: [Wish] = [
        Wish(title: "Yeni Bisiklet", estimatedCost: 8000, isApproved: false)
    ]

    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddTransaction = false

    var totalBalance: Decimal {
        transactions.reduce(0) { result, tx in
            switch tx.type {
            case .income:
                return result + tx.amount
            case .expense:
                return result - tx.amount
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Kullanıcı ve Bakiye
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hoş geldin, \(userName)!")
                            .font(.title2).bold()
                            .foregroundColor(.primary)
                        Text("Toplam Bakiye")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(totalBalance.formatted(.number.precision(.fractionLength(2)))) \(currency)")
                            .font(.largeTitle).bold()
                            .foregroundColor(totalBalance >= 0 ? .green : .red)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    // Hedefler
                    if !goals.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Hedefler")
                                .font(.headline)
                                .foregroundColor(.primary)
                            ForEach(goals, id: \.id) { goal in
                                GoalCard(goal: goal)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // İstekler
                    if !wishes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("İstekler")
                                .font(.headline)
                                .foregroundColor(.primary)
                            ForEach(wishes, id: \.id) { wish in
                                WishCard(wish: wish)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Son İşlemler
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Son İşlemler")
                            .font(.headline)
                            .foregroundColor(.primary)
                        ForEach(transactions, id: \.id) { tx in
                            TransactionRow(transaction: tx)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("ParAi")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddTransaction = true }) {
                        Label("İşlem Ekle", systemImage: "plus")
                    }
                    .frame(minWidth: 44, minHeight: 44)
                }
            }
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView { newTransaction in
                    modelContext.insert(newTransaction)
                }
            }
        }
    }
}

// MARK: - Alt Bileşenler

struct GoalCard: View {
    let goal: Goal

    var progress: Double {
        guard goal.targetAmount > 0 else { return 0 }
        return min(Double(truncating: goal.currentAmount as NSNumber) / Double(truncating: goal.targetAmount as NSNumber), 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.title)
                .font(.subheadline).bold()
            ProgressView(value: progress)
                .accentColor(.blue)
            HStack {
                Text("Hedef: \(goal.targetAmount.formatted(.number)) ₺")
                    .font(.caption)
                Spacer()
                Text("Kalan: \((goal.targetAmount - goal.currentAmount).formatted(.number)) ₺")
                    .font(.caption)
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 2)
        .frame(minHeight: 44) // Apple UI Design Tips: Hit target
    }
}

struct WishCard: View {
    let wish: Wish

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(wish.title)
                    .font(.subheadline).bold()
                Text("Tahmini: \(wish.estimatedCost.formatted(.number)) ₺")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if wish.isApproved {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .accessibilityLabel("Onaylandı")
            } else {
                Image(systemName: "hourglass")
                    .foregroundColor(.orange)
                    .accessibilityLabel("Beklemede")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .frame(minHeight: 44)
    }
}

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(transaction.type == .income ? Color.green : Color.red)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: transaction.type == .income ? "arrow.down.circle" : "arrow.up.circle")
                        .foregroundColor(.white)
                        .font(.title3)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category)
                    .font(.body).bold()
                Text(transaction.note ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(transaction.amount.formatted(.number.precision(.fractionLength(2)))) ₺")
                .font(.body)
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 4)
        .frame(minHeight: 44)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
} 