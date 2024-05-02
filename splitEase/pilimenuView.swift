import SwiftUI
//enum Anchor {
//    case top, bottom
//}

struct pilimenuView: View {
    @Binding var names: [String]
    @State private var selectedNameIndex = 0
    @Binding var subtotal: String
    @Binding var serviceCharge: String
    @Binding var tax: String
    @Binding var discountBawah: String
    @Binding var totalAmount: String
    @Binding var itemInputs: [ItemInput] // Array untuk menyimpan data item
    @State private var checkedIndices2: [String: [Int: Int]] = [:]

    @State private var checkedIndices: [String: Set<Int>] = [:]
//    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = 180
    var cornerRadius: CGFloat = 5
    @Binding var selection: String?
    @State private var showOptions: Bool = false
    @Environment(\.colorScheme) private var scheme


    var body: some View {
        VStack{
            Text("")
                .padding(.bottom,5)
            ScrollView{
                VStack {
                    VStack(spacing: 0){
                        HStack(spacing: 0) {
                            Text(selection ?? "Choose name")
                                .lineLimit(1)
                            
                            Spacer(minLength: 0)
                            Image (systemName: "chevron.down")
                                .font(.title3)
                                .foregroundStyle(.gray)
                                .rotationEffect(.init(degrees: showOptions ? -180 : 0))
                        }

                        .padding(.horizontal, 15)
                        .frame(height: 40)
                        .contentShape(.rect)
                        if showOptions{
                            OptionsView()
                        }
                    }
                    .onTapGesture {
                        withAnimation(.snappy) {
                            showOptions.toggle() // Toggle the state of showOptions
                        }
                    }
                    .background((scheme == .dark ? Color.black :
                                    Color.white) .shadow(.drop(color: .primary.opacity(0.15), radius: 4)), in: .rect(cornerRadius: cornerRadius))
                }
                .padding(.horizontal)
                .padding(.vertical,10)

                .frame(maxWidth: .infinity)
                ForEach(itemInputs.indices, id: \.self) { index in
                    if let cekItem = Double(itemInputs[index].hasilKali), cekItem != 0 {
                        HStack{
                            Text("\(itemInputs[index].itemName)")
                                .padding(.leading, 18)
                            Spacer()
                            Button(action: {
                                if let selectedName = selection {
                                    if checkedIndices[selectedName]?.contains(index) ?? false {
                                        checkedIndices[selectedName]?.remove(index)
                                    } else {
                                        checkedIndices[selectedName, default: []].insert(index)
                                    }
                                }
                            }) {
                                Image(systemName: checkedIndices[selection ?? ""]?.contains(index) ?? false ? "checkmark.circle" : "circle")
                                    .padding(.trailing, 18)
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                            }
                            
                        }
                        
                        HStack{
                            Text("\(itemInputs[index].price)")
                                .padding(.leading, 18)
                                .foregroundStyle(.gray)
                                .frame(width: 140, alignment: .leading)
                            
                            Spacer()
                            HStack{
                                Button(action: {
                                    let name = selection ?? ""
                                    if var quantities = checkedIndices2[name], let currentQuantity = quantities[index], currentQuantity > 0 {
                                        quantities[index] = currentQuantity - 1
                                        checkedIndices2[name] = quantities
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                }

                                Text("\(checkedIndices2[selection ?? ""]?[index] ?? 0)")

                                Button(action: {
                                    let name = selection ?? ""
                                    
                                    if var quantities = checkedIndices2[name] {
                                        quantities[index, default: 0] += 1
                                        checkedIndices2[name] = quantities
                                    } else {
                                        var quantities: [Int: Int] = [:]
                                        quantities[index] = 1
                                        checkedIndices2[name] = quantities
                                    }
                                }) {
                                    Image(systemName: "plus.circle")
                                }
                            }

                            Spacer()
                            Text("\(itemInputs[index].hasilKali)")
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
                                Text("-\(itemInputs[index].discount)")
                                    .padding(.trailing, 18)
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        
                        Text("----------------------------------------------------")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                    }

                }
            }
            .frame(width: 333)
            .background(Color(red: 1, green: 0.99, blue: 0.91))
            .cornerRadius(10)
            .font(.callout)
            
//            NavigationLink(destination: tesView().navigationBarTitle("Bill Details")) {
//                HStack {
//                    Image(systemName: "checkmark.circle")
//                        .padding(.vertical)
//                        .foregroundColor(.white)
//                    Text("Confirm")
//                        .padding(.vertical)
//                        .foregroundColor(.white)
//                }
//                .frame(width: 333)
//                .background(Color(red: 135/255, green: 167/255, blue: 156/255))
//                .cornerRadius(10)
//
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.81, green: 0.87, blue: 0.80))
    }
    
    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 10) {
            ForEach(names, id: \.self) { name in
                HStack(spacing: 0) {
                    Text(name)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                    Image(systemName: "checkmark")
                        .opacity(selection == name ? 1 : 0)
                        .foregroundColor(selection == name ? Color.primary : Color.gray)
                        .animation(.none, value: selection)
                        .frame(height: 40)
                        .contentShape(Rectangle())

                }
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = name
                        showOptions = false
                    }
                }
            }
        }
        .padding(.horizontal, 15)
    }


}

//struct PickMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        let names = Binding.constant(["John", "Doe"]) // Inisialisasi Binding untuk names
//        return PickMenuView(names: names)
//    }
//}
