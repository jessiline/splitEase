import SwiftUI

struct ItemInputView: View {
    var index: Int
    @Binding var itemName: String
    @Binding var price: String
    @Binding var qty: String
    @Binding var hasilKali: String
    @Binding var discount: String
    @Binding var showDiscount: Bool
    var onRemoveDiscount: () -> Void
    @State private var isActionSheetVisible = false
    var onDelete: () -> Void // Callback for delete action


    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    var body: some View {
        HStack {
            TextField("Item's Name", text: $itemName)
                .listRowBackground(Color.green)
                .padding(.vertical, 7)
                .padding(.leading, 30)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .padding(.leading,18)
                )
            Button(action: {
                isActionSheetVisible = true
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.black)
                    .padding(.trailing,15)
            }
            .actionSheet(isPresented: $isActionSheetVisible) {
                ActionSheet(title: Text("Options"), buttons: [
                    .default(Text("Add Discount")) {
                        if !showDiscount { // Check if discount is not already shown
                            showDiscount = true
                        }
                    },
                    .destructive(Text("Delete")) {
                        onDelete()
                    },
                    .cancel()
                ])
            }
        }
        .padding(.top)
        .padding(.bottom,5)


        HStack {
            TextField("Price", text: $price)
                .frame(width: 87)
                .padding(.vertical, 7)
                .padding(.leading, 30)
                .background(Color.clear)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .padding(.leading, 18)
                )
                .onChange(of: price) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    let formatted = formatPrice(filtered)
                    price = formatted
                    calculateResult()
                }
            
            Spacer()
            
            TextField("Qty", text: $qty)
                .frame(width: 32)
                .padding(.vertical, 7)
                .padding(.leading, 5)
                .background(Color.clear)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .frame(width: 50)
                .onChange(of: qty) { newValue in
                    calculateResult()
                    print("Typed \(newValue) in group \(index)")
                }
            
            Spacer()
            
            TextField("", text: $hasilKali)
                .listRowBackground(Color.green)
                .frame(width: 80)
                .padding(.vertical, 7)
                .padding(.trailing, 30)
                .background(Color.clear)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .padding(.trailing, 18)
                )
                .multilineTextAlignment(.trailing)
                .disabled(true)
        }
        .keyboardType(.numberPad)
        .font(.system(size: 15))
        if showDiscount { // Show the discount HStack if showDiscount is true
            HStack {
                Button(action: {
                    onRemoveDiscount()
                }) {
                    HStack {
                        Image(systemName: "xmark")
                            .padding(.leading)
                            .padding(.top,5)
                            .foregroundColor(.gray)
                            .font(.caption)

                        Text("Discounts")
                            .padding(.top,5)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                TextField("", text: $discount)
                    .listRowBackground(Color.green)
                    .frame(width: 80)
                    .padding(.vertical, 7)
                    .padding(.trailing, 30)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .padding(.trailing, 18)
                    )
                    .multilineTextAlignment(.trailing)
                    .onChange(of: discount) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        let formatted = formatPrice(filtered)
                        discount = formatted
                    }
            }
            .keyboardType(.numberPad)

        }

        Text("----------------------------------------------------")
            .font(.caption)
            .foregroundStyle(.gray)
    }
    
    private func calculateResult() {
        if let priceValue = Double(price.replacingOccurrences(of: ".", with: "")), let qtyValue = Double(qty) {
            let result = priceValue * qtyValue
            hasilKali = numberFormatter.string(from: NSNumber(value: result)) ?? ""
        } else {
            hasilKali = ""
        }
    }
    func doneButtonTapped() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    private func formatPrice(_ price: String) -> String {
        guard let number = numberFormatter.number(from: price) else {
            return ""
        }
        return numberFormatter.string(from: number) ?? ""
    }
}
