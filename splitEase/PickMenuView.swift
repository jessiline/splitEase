import SwiftUI

struct ItemInputState: Hashable {
    var itemName: String
    var qty: Int {
        didSet {
            updateNewHasilKali()
            updateNewDiscount()
        }
    }
    var isChecked: Bool
    var newHasilKali: String
    var newDiscount: String

    private mutating func updateNewHasilKali() {
        let price = itemInput.price.replacingOccurrences(of: ".", with: "")
        if let priceValue = Double(price) {
            let newHasilKaliValue = priceValue * Double(qty)
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 0
            if let formattedString = formatter.string(from: NSNumber(value: newHasilKaliValue)) {
                newHasilKali = formattedString
            }
        }
    }

    private mutating func updateNewDiscount() {
        // Update newDiscount when qty changes
        let discount = itemInput.discount.replacingOccurrences(of: ".", with: "")
        if let discountValue = Double(discount), discountValue != 0 {
            let newDiscountValue = (Double(qty) * discountValue) / Double(itemInput.qty)!
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 0
            if let formattedString = formatter.string(from: NSNumber(value: newDiscountValue)) {
                newDiscount = formattedString
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(itemName) // Use itemName for hashing
        hasher.combine(qty)
        hasher.combine(isChecked)
        hasher.combine(newHasilKali)
        hasher.combine(newDiscount)
    }

    static func == (lhs: ItemInputState, rhs: ItemInputState) -> Bool {
        return lhs.itemName == rhs.itemName && // Compare itemName
               lhs.qty == rhs.qty &&
               lhs.isChecked == rhs.isChecked &&
               lhs.newHasilKali == rhs.newHasilKali &&
               lhs.newDiscount == rhs.newDiscount
    }
    var itemInput: ItemInput 
}

struct PickMenuView: View {
    @Binding var names: [String]
    @Binding var subtotal: String
    @Binding var serviceCharge: String
    @Binding var tax: String
    @Binding var discountBawah: String
    @Binding var totalAmount: String
    @Binding var itemInputs: [ItemInput]
    @State private var selectedOption: String? = nil
    @State private var selectedOptionStates: [String: [ItemInputState]] = [:]
    @State private var showAlert = false
    @State private var isExpanded = false

    var body: some View {
        VStack {
            Text("")
                .padding(.bottom, 5)
            ScrollView {
                Text("")
                VStack {
                    VStack {
                        Button(action: {
                            withAnimation {
                                self.isExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Text(selectedOption ?? "")
                                    .padding()
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .padding()
                                    .foregroundColor(.black)
                            }
                            .frame(height: 44)
                            .background(.white)
                        }
                        .cornerRadius(8)

                        if isExpanded {
                            VStack(spacing: 0) {
                                ForEach(names, id: \.self) { option in
                                    Button(action: {
                                        self.selectedOption = option
                                        self.isExpanded = false
                                    }) {
                                        HStack{
                                            Text(option)
                                                .padding()
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                        }

                    }
                    .frame(width: 300)
                    .padding()
                    .onAppear {
                        self.selectedOption = names.first
                        self.initializeSelectedOptionStates()
                    }
                    Spacer()
                }

                ForEach(itemInputs.indices, id: \.self) { index in
                    if let states = selectedOptionStates[selectedOption ?? ""] {
                        if let itemStateIndex = states.firstIndex(where: { $0.itemName == itemInputs[index].itemName }) {
                            let itemState = Binding<ItemInputState>(
                                get: { states[itemStateIndex] },
                                set: { newValue in
                                    var updatedStates = states
                                    updatedStates[itemStateIndex] = newValue
                                    selectedOptionStates[selectedOption ?? ""] = updatedStates
                                }
                            )
                            
                            HStack {
                                Text("\(itemInputs[index].itemName)")
                                    .padding(.leading, 18)
                                Spacer()
                                Button(action: {
                                    itemState.wrappedValue.isChecked.toggle()
                                }) {
                                    Image(systemName: itemState.wrappedValue.isChecked ? "checkmark.circle" : "circle")
                                        .font(.system(size: 18))
                                        .padding(.trailing)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            HStack{
                                Text("\(itemInputs[index].price)")
                                    .padding(.leading, 18)
                                    .foregroundStyle(.gray)
                                    .frame(width: 100, alignment: .leading)
                                
                                Spacer()
                                VStack {
                                    HStack {
                                        Button(action: {
                                            if itemState.wrappedValue.qty > 0 {
                                                itemState.wrappedValue.qty -= 1
                                            }
                                        }) {
                                            Image(systemName: "minus")
                                        }
                                        Text("\(itemState.wrappedValue.qty)")
                                        Button(action: {
                                            if itemState.wrappedValue.qty < Int(itemInputs[index].qty) ?? 0 {
                                                itemState.wrappedValue.qty += 1
                                            }
                                        }) {
                                            Image(systemName: "plus")
                                        }
                                    }
                                    .padding(.vertical,5)
                                    .padding(.horizontal,10)
                                    .foregroundColor(.black)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(20)
                                }
                                
                                Spacer()
                                Text("\(itemState.wrappedValue.newHasilKali)") // Display newHasilKali
                                    .padding(.trailing, 18)
                                    .frame(width: 105, alignment: .trailing)
                                
                            }
                            .padding(.vertical,5)
                            
                            if let discount = Double(itemInputs[index].discount), discount != 0 {
                                HStack {
                                    Text("Discounts")
                                        .padding(.leading, 18)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("-\(itemState.wrappedValue.newDiscount)") // Display newDiscount
                                        .padding(.trailing, 18)
                                        .foregroundStyle(.green)
                                }
                            }
                            
                            Text("----------------------------------------------------")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .padding(.bottom,10)
                        }
                    }
                    
                }
            }
            .frame(width: 333)
            .background(Color(red: 1, green: 0.99, blue: 0.91))
            .cornerRadius(10)
            .font(.callout)
            
            NavigationLink(destination: FinalBillView(selectedOptionStates: $selectedOptionStates,subtotal: $subtotal, serviceCharge: $serviceCharge, tax: $tax, discountBawah: $discountBawah, totalAmount: $totalAmount).navigationBarTitle("Bill Details")) { // Passing selectedOptionStates to FinalBillView
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
            .padding(.vertical,20)
            .disabled(selectedOptionStates.allSatisfy { $0.value.allSatisfy { !$0.isChecked } })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Input Data!"), dismissButton: .default(Text("OK")))
            }
            .onTapGesture {
                if selectedOptionStates.allSatisfy { $0.value.allSatisfy { !$0.isChecked } } {
                    showAlert = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.81, green: 0.87, blue: 0.80))
        .font(.system(size: 15))
        .onAppear(){
            itemInputs.removeAll(where: { $0.hasilKali.isEmpty })
            names.removeAll(where: { $0.isEmpty })
        }
    }

    private func initializeSelectedOptionStates() {
        for name in names {
            var initialStates: [ItemInputState] = []
            for input in itemInputs {
                let qty = Int(input.qty) ?? 0
                let newHasilKali = calculateNewHasilKali(itemInput: input, qty: qty)
                let newDiscount = calculateNewDiscount(itemInput: input, qty: qty)
                initialStates.append(ItemInputState(itemName: input.itemName, qty: qty, isChecked: false, newHasilKali: newHasilKali, newDiscount: newDiscount, itemInput: input))
            }
            selectedOptionStates[name] = initialStates
        }
    }
    
    private func calculateNewHasilKali(itemInput: ItemInput, qty: Int) -> String {
        let price = itemInput.price.replacingOccurrences(of: ".", with: "") // Remove "."
        if let priceValue = Double(price) {
            let newHasilKali = priceValue * Double(qty)
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 0
            if let formattedString = formatter.string(from: NSNumber(value: newHasilKali)) {
                return formattedString
            }
        }
        return ""
    }

    private func calculateNewDiscount(itemInput: ItemInput, qty: Int) -> String {
        let discount = itemInput.discount.replacingOccurrences(of: ".", with: "") // Remove "."
        if let discountValue = Double(discount), discountValue != 0 {
            let newDiscountValue = (Double(qty) * discountValue) / Double(itemInput.qty)!
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 0
            if let formattedString = formatter.string(from: NSNumber(value: newDiscountValue)) {
                return formattedString
            }
        }
        return ""
    }
}
