import SwiftUI
struct ItemInput {
    var itemName: String = ""
    var price: String = ""
    var qty: String = ""
    var hasilKali: String = ""
    var discount: String = "" // Define a discount variable
    var showDiscount: Bool = false
}

struct InputBillView: View {
    @Binding var itemInputs: [ItemInput]
    @FocusState private var isTextFieldFocused: Bool
    @State private var deleteIndex: Int?
    @Binding var subtotal: String
    @Binding var serviceCharge: String
    @Binding var tax: String
    @Binding var discountBawah: String
    @Binding var totalAmount: String


    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
            VStack() {
                VStack {
                    Text("")
                        .padding(.bottom,5)
//                    Spacer()
                    ScrollView{
                        ForEach(itemInputs.indices, id: \.self) { index in
                            ItemInputView(
                                index: index,
                                itemName: $itemInputs[index].itemName,
                                price: $itemInputs[index].price,
                                qty: $itemInputs[index].qty,
                                hasilKali: $itemInputs[index].hasilKali,
                                discount: $itemInputs[index].discount,
                                showDiscount: $itemInputs[index].showDiscount,
                                onRemoveDiscount: { removeDiscount(forIndex: index) },
                                onDelete: { deleteIndex = index } // Set deleteIndex when delete button is pressed
                            )
                            .focused($isTextFieldFocused)
                        }
                        Button(action: {
                            itemInputs.append(ItemInput())
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .padding(.leading)
                                    .padding(.top)
                                Text("Add Item")
                                    .padding(.top)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                        .onReceive(itemInputs.publisher) { _ in
                            let total = itemInputs.reduce(0) { $0 + (Int($1.hasilKali.replacingOccurrences(of: ".", with: "")) ?? 0) }
                            let disc = itemInputs.reduce(0) { $0 + (Int($1.discount.replacingOccurrences(of: ".", with: "")) ?? 0) }
                            subtotal = numberFormatter.string(from: NSNumber(value: total-disc)) ?? ""
                        }
                        VStack{
                            HStack {
                                Button(action: {
                                }) {
                                    Text("Subtotal")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 18)
                                    Spacer()
                                    
                                }
                                TextField("", text: $subtotal)
//                                    .font(.system(size: 15))
                                    .padding(.trailing, 30)
                                    .background(Color.clear)
                                    .cornerRadius(12)
                                    .multilineTextAlignment(.trailing)
                                    .disabled(true)
                                    .onChange(of: subtotal) { newValue in
                                        calculateResult()
                                    }
                                
                            }
                            .padding(.top,20)
                            HStack {
                                Button(action: {
                                }) {
                                    Text("Tax")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 18)
                                    Spacer()
                                    
                                }
                                TextField("", text: $tax)
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
                                    .onChange(of: tax) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        let formatted = formatValue(filtered, type: "tax")
                                        tax = formatted
                                        calculateResult()
                                    }
                                
                                
                                
                            }
                            .padding(.top,5)
                            HStack {
                                Button(action: {
                                }) {
                                    Text("Service charge")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 18)
                                    Spacer()
                                    
                                }
                                TextField("", text: $serviceCharge)
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
                                    .onChange(of: serviceCharge) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        let formatted = formatValue(filtered, type: "serviceCharge")
                                        serviceCharge = formatted
                                        calculateResult()
                                        
                                    }
                            }
                            HStack {
                                Button(action: {
                                }) {
                                    Text("Discounts")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 18)
                                    Spacer()
                                    
                                }
                                TextField("", text: $discountBawah)
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
                                    .onChange(of: discountBawah) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        let formatted = formatValue(filtered, type: "discount")
                                        discountBawah = formatted
                                        calculateResult()
                                    }
                            }
                            HStack {
                                Button(action: {
                                }) {
                                    Text("Total amount")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 18)
                                    Spacer()
                                    
                                }
                                TextField("", text: $totalAmount)
                                    .font(.headline)
                                    .padding(.trailing, 30)
                                    .background(Color.clear)
                                    .cornerRadius(12)
                                    .multilineTextAlignment(.trailing)
                                    .disabled(true)
                            }
                            .padding(.top,10)
                            .padding(.bottom,30)
                            
                        }
                        .keyboardType(.numberPad)
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Spacer()
                            }
                            ToolbarItem(placement: .keyboard) {
                                Button("Done") {
                                    doneButtonTapped()
                                }
                                .foregroundColor(.blue)
                            }
                        }
                        .focused($isTextFieldFocused)
                        
                        
                        
                    }
                    .frame(width: 333)
                    .background(Color(red: 1, green: 0.99, blue: 0.91))
                    .cornerRadius(10)
                    
                
                    NavigationLink(destination: BillDetailsView(subtotal: $subtotal, serviceCharge: $serviceCharge, tax: $tax, discountBawah: $discountBawah, totalAmount: $totalAmount, itemInputs: $itemInputs).navigationBarTitle("Bill Details")) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .padding(.vertical)
                                .foregroundColor(.white)
                            Text("Confirm")
                                .padding(.vertical)
                                .foregroundColor(.white)
                        }
                        .frame(width: 333)
                        .background(Color(red: 135/255, green: 167/255, blue: 156/255))
                        .cornerRadius(10)
                        
                    }
                    .opacity(isTextFieldFocused ? 0 : 1)
                    .padding(.vertical, isTextFieldFocused ? -20 : 20)
                }
                .onChange(of: deleteIndex) { index in
                    if let index = index {
                        itemInputs.remove(at: index) // Remove item at deleteIndex
                        deleteIndex = nil // Reset deleteIndex
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.81, green: 0.87, blue: 0.80))
                .font(.system(size: 15))            }

    }
    func removeDiscount(forIndex index: Int) {
        itemInputs[index].showDiscount = false
        itemInputs[index].discount = "" // Clear discount value
    }
    func doneButtonTapped() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func formatValue(_ value: String, type: String) -> String {
        guard let number = numberFormatter.number(from: value) else {
            return ""
        }
        
        switch type {
        case "price":
            return numberFormatter.string(from: number) ?? ""
        case "tax", "serviceCharge", "discount":
            return numberFormatter.string(from: number) ?? ""
        default:
            return ""
        }
    }
    
    private func calculateResult() {
        let subtotalValue = Double(subtotal.replacingOccurrences(of: ".", with: "")) ?? 0
        let taxValue = Double(tax.replacingOccurrences(of: ".", with: "")) ?? 0
        let serviceValue = Double(serviceCharge.replacingOccurrences(of: ".", with: "")) ?? 0
        let discountValue = Double(discountBawah.replacingOccurrences(of: ".", with: "")) ?? 0
        
        if subtotalValue != 0 || taxValue != 0 || serviceValue != 0 || discountValue != 0 {
            let result = subtotalValue + taxValue + serviceValue - discountValue
            totalAmount = numberFormatter.string(from: NSNumber(value: result)) ?? ""
        } else {
            totalAmount = "0"
        }
    }


}

