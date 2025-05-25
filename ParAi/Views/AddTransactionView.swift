import SwiftUI

struct Category: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let icon: String
}

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var type: TransactionType = .expense
    @State private var selectedCategoryIndex: Int = 0
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var note: String = ""
    @State private var repeatIntervalDays: Int = 0
    @State private var wantOrNeed: Bool? = nil
    @State private var showValidationError: Bool = false
    @FocusState private var amountIsFocused: Bool

    var onSave: ((Transaction) -> Void)? = nil

    // Kategoriler
    let incomeCategories: [Category] = [
        .init(name: "Maaş", icon: "banknote"),
        .init(name: "Prim", icon: "gift"),
        .init(name: "Ek Gelir", icon: "plus.circle"),
        .init(name: "Hediye", icon: "gift.fill"),
        .init(name: "Yatırım", icon: "chart.bar"),
        .init(name: "Satış", icon: "cart"),
        .init(name: "Faiz Geliri", icon: "dollarsign.circle"),
        .init(name: "Kira Geliri", icon: "house"),
        .init(name: "Devlet Desteği", icon: "building.columns"),
        .init(name: "İkramiye", icon: "star.circle"),
        .init(name: "Serbest Çalışma", icon: "person.crop.circle.badge.checkmark"),
        .init(name: "Geri Ödeme", icon: "arrow.uturn.left.circle"),
        .init(name: "Burs", icon: "graduationcap"),
        .init(name: "Diğer", icon: "ellipsis")
    ]
    let expenseCategories: [Category] = [
        .init(name: "Market", icon: "cart.fill"),
        .init(name: "Ulaşım", icon: "car.fill"),
        .init(name: "Fatura", icon: "doc.text.fill"),
        .init(name: "Kira", icon: "house.fill"),
        .init(name: "Eğlence", icon: "gamecontroller.fill"),
        .init(name: "Sağlık", icon: "cross.case.fill"),
        .init(name: "Giyim", icon: "tshirt.fill"),
        .init(name: "Yeme-İçme", icon: "fork.knife"),
        .init(name: "Eğitim", icon: "book.fill"),
        .init(name: "Teknoloji", icon: "desktopcomputer"),
        .init(name: "Ev", icon: "bed.double.fill"),
        .init(name: "Çocuk", icon: "figure.child"),
        .init(name: "Hobi", icon: "paintbrush.fill"),
        .init(name: "Seyahat", icon: "airplane"),
        .init(name: "Vergi", icon: "percent"),
        .init(name: "Bağış", icon: "heart.fill"),
        .init(name: "Evcil Hayvan", icon: "pawprint.fill"),
        .init(name: "Kredi Kartı Ödemesi", icon: "creditcard.fill"),
        .init(name: "Sigorta", icon: "shield.fill"),
        .init(name: "Kişisel Bakım", icon: "scissors"),
        .init(name: "Abonelikler", icon: "rectangle.stack.person.crop.fill"),
        .init(name: "Borç Ödemesi", icon: "arrow.up.right.square"),
        .init(name: "Diğer", icon: "ellipsis")
    ]

    var currentCategories: [Category] {
        type == .income ? incomeCategories : expenseCategories
    }

    var selectedCategory: Category? {
        guard currentCategories.indices.contains(selectedCategoryIndex) else { return nil }
        return currentCategories[selectedCategoryIndex]
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // Card
                ScrollView {
                    VStack(spacing: 24) {
                        // Tür seçimi
                        Picker("Tür", selection: $type) {
                            Text("Gelir").tag(TransactionType.income)
                            Text("Gider").tag(TransactionType.expense)
                        }
                        .pickerStyle(.segmented)
                        .padding(.top, 16)
                        .onChange(of: type) { _ in selectedCategoryIndex = 0 }

                        // Kategori seçimi
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Kategori")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.leading, 8)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(currentCategories.indices, id: \.self) { idx in
                                        let cat = currentCategories[idx]
                                        Button(action: {
                                            withAnimation(.spring()) { selectedCategoryIndex = idx }
                                        }) {
                                            VStack(spacing: 4) {
                                                ZStack {
                                                    Circle()
                                                        .fill(selectedCategoryIndex == idx ? (type == .income ? Color.green : Color.red) : Color(.secondarySystemBackground))
                                                        .frame(width: 48, height: 48)
                                                    Image(systemName: cat.icon)
                                                        .font(.title2)
                                                        .foregroundColor(selectedCategoryIndex == idx ? .white : (type == .income ? Color.green : Color.red))
                                                }
                                                Text(cat.name)
                                                    .font(.caption)
                                                    .foregroundColor(selectedCategoryIndex == idx ? (type == .income ? Color.green : Color.red) : .primary)
                                            }
                                            .padding(.vertical, 2)
                                            .padding(.horizontal, 4)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(selectedCategoryIndex == idx ? (type == .income ? Color.green.opacity(0.12) : Color.red.opacity(0.12)) : Color.clear)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                            }
                        }

                        // Tutar
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tutar")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.leading, 8)
                            HStack {
                                TextField("0,00", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.leading)
                                    .focused($amountIsFocused)
                                    .accessibilityLabel("Tutar")
                                Text("₺")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)
                            .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { amountIsFocused = true } }
                        }

                        // Tarih
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tarih")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.leading, 8)
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                        }

                        // Not
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Not")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.leading, 8)
                            TextField("Açıklama (isteğe bağlı)", text: $note)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                        }

                        // Tekrar ve ihtiyaç
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tekrar")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 8)
                                Stepper(value: $repeatIntervalDays, in: 0...365, step: 1) {
                                    Text(repeatIntervalDays > 0 ? "\(repeatIntervalDays) günde bir" : "Tek seferlik")
                                }
                                .padding(.horizontal, 8)
                            }
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("İhtiyaç mı?")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 8)
                                Picker("İhtiyaç mı?", selection: Binding(
                                    get: { wantOrNeed ?? false ? 1 : (wantOrNeed == nil ? -1 : 0) },
                                    set: { newValue in
                                        wantOrNeed = newValue == -1 ? nil : (newValue == 1)
                                    }
                                )) {
                                    Text("Belirsiz").tag(-1)
                                    Text("İhtiyaç").tag(1)
                                    Text("İstek").tag(0)
                                }
                                .pickerStyle(.segmented)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 8)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 4)
                        .padding(.bottom, 8)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 80)
                }

                // Kaydet butonu
                VStack {
                    Button(action: {
                        if isFormValid {
                            if let newTransaction = createTransaction() {
                                onSave?(newTransaction)
                            }
                            dismiss()
                        } else {
                            withAnimation { showValidationError = true }
                        }
                    }) {
                        Text("Kaydet")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: .accentColor.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    .disabled(!isFormValid)
                }
                .background(Color(.systemGroupedBackground).opacity(0.95).ignoresSafeArea())
            }

            // Hatalı giriş uyarısı
            if showValidationError {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                        Text("Lütfen tüm zorunlu alanları doldurun ve geçerli bir tutar girin.")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 8)
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { showValidationError = false } } }
            }
        }
        .onTapGesture {
            if amountIsFocused {
                amountIsFocused = false
            }
        }
        .navigationTitle("İşlem Ekle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Vazgeç") { dismiss() }
            }
        }
    }

    var isFormValid: Bool {
        (selectedCategory?.name.isEmpty == false) && Decimal(string: amount.replacingOccurrences(of: ",", with: ".")) != nil
    }

    func createTransaction() -> Transaction? {
        guard
            let selectedCategory = selectedCategory,
            !selectedCategory.name.isEmpty,
            let amountDecimal = Decimal(string: amount.replacingOccurrences(of: ",", with: "."))
        else { return nil }
        return Transaction(
            type: type,
            category: selectedCategory.name,
            amount: amountDecimal,
            date: date,
            note: note.isEmpty ? nil : note,
            repeatIntervalDays: Int16(repeatIntervalDays),
            wantOrNeed: wantOrNeed
        )
    }
}

// MARK: - Preview

#Preview {
    AddTransactionView()
} 