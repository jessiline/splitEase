//
//  BillDetailsView.swift
//  splitEase
//
//  Created by jessiline imanuela on 28/04/24.
//

import SwiftUI

struct BillDetailsView: View {
    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    func formatNumber(_ number: Double) -> String {
        guard let formattedString = numberFormatter.string(from: NSNumber(value: number)) else {
            return ""
        }
        return formattedString
    }
    @State private var splitCounts = [Int: Int]()
    func splitItem(index: Int) {
            let count = splitCounts[index] ?? 2
            splitCounts[index] = count + 1

            guard let quantity = Int(itemInputs[index].qty),
                  quantity > 1,
                  let price = Double(itemInputs[index].price.replacingOccurrences(of: ".", with: "")),
                  let hasilKali = Double(itemInputs[index].hasilKali.replacingOccurrences(of: ".", with: "")) else {
                return
            }

            let newQuantity = quantity - 1
            let newHasilKali = price * Double(newQuantity)
            var newItemDiscount = 0
            if let discount = Double(itemInputs[index].discount.replacingOccurrences(of: ".", with: "")), discount != 0 {
                newItemDiscount = Int(discount / Double(quantity))
                itemInputs[index].discount = formatNumber(Double(newItemDiscount) * Double(newQuantity))
            }
            // Update existing item
            itemInputs[index].qty = "\(newQuantity)"
            itemInputs[index].hasilKali = formatNumber(newHasilKali)
                
        
                // Add new item
            let newItem = ItemInput(itemName: "\(itemInputs[index].itemName)(\(count))",
                                    price: formatNumber(price),
                                    qty: "\(1)",
                                    hasilKali: formatNumber(price),
                                    discount: formatNumber(Double(newItemDiscount)),
                                    showDiscount: itemInputs[index].showDiscount
            )
            itemInputs.insert(newItem, at: index + 1)

        }
    
    @Binding var subtotal: String
    @Binding var serviceCharge: String
    @Binding var tax: String
    @Binding var discountBawah: String
    @Binding var totalAmount: String
    @Binding var itemInputs: [ItemInput] // Array untuk menyimpan data item
    @State private var names: [String] = []
    
    
    var body: some View {
            VStack{
                Text("")
                    .padding(.bottom,5)
                ScrollView{
                    Text("")
                    ForEach(itemInputs.indices, id: \.self) { index in
                        HStack{
                            Text("\(itemInputs[index].itemName)")
                                .padding(.leading, 18)
                            Spacer()
                            if let cekQty = Double(itemInputs[index].qty), cekQty > 1 {
                                Button(action: {
                                    splitItem(index: index)
                                }) {
                                    Text("Split")
                                        .padding(.trailing, 18)
                                }
                            }
                        }
                        
                        HStack{
                            Text("\(itemInputs[index].price)")
                                .padding(.leading, 18)
                                .foregroundStyle(.gray)
                                .frame(width: 140, alignment: .leading)
                            
                            Spacer()
                            Text("\(itemInputs[index].qty) x")
                                .foregroundStyle(.gray)
                                .frame(width: 50, alignment: .leading)
                            
                            Spacer()
                            Text("\(itemInputs[index].hasilKali)")                                .padding(.trailing, 18)
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
                    HStack{
                        Text("Subtotal")
                            .padding(.leading, 18)
                            .foregroundStyle(.gray)
                        Spacer()
                        Text(subtotal)
                            .padding(.trailing, 18)
                    }
                    .padding(.top,20)

                    HStack{
                        Text("Tax")
                            .padding(.leading, 18)
                            .foregroundStyle(.gray)
                        Spacer()
                        Text(tax)
                            .padding(.trailing, 18)
                    }
                    .padding(.top,5)

                    HStack{
                        Text("Service charge")
                            .padding(.leading, 18)
                            .foregroundStyle(.gray)
                        Spacer()
                        Text(serviceCharge)
                            .padding(.trailing, 18)
                    }
                    .padding(.top,5)

                    HStack{
                        Text("Discounts")
                            .padding(.leading, 18)
                            .foregroundStyle(.gray)
                        Spacer()
                        Text(discountBawah)
                            .padding(.trailing, 18)
                    }
                    .padding(.top,5)

                    HStack{
                        Text("Total amount")
                            .padding(.leading, 18)
                            .foregroundStyle(.gray)
                        Spacer()
                        Text(totalAmount)
                            .padding(.trailing, 18)
                            .font(.headline)
                    }
                    .padding(.top,5)

                 
                }
                .frame(width: 333)
                .background(Color(red: 1, green: 0.99, blue: 0.91))
                .cornerRadius(10)
                .font(.callout)
                
                HStack{
                    NavigationLink(destination: InputBillView(itemInputs: $itemInputs, subtotal: $subtotal, serviceCharge: $serviceCharge, tax: $tax, discountBawah: $discountBawah, totalAmount: $totalAmount).navigationBarTitle("Input Bill")) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.white)
                            Text("Edit")
                                .padding(.vertical)
                                .foregroundColor(.white)
                        }
                        .frame(width: 160)
                        .background(Color(red: 113/255, green: 120/255, blue: 146/255))
                        .cornerRadius(10)
                        
                    }
                    NavigationLink(destination: AddPersonView(names: $names, subtotal: $subtotal, serviceCharge: $serviceCharge, tax: $tax, discountBawah: $discountBawah, totalAmount: $totalAmount, itemInputs: $itemInputs).navigationBarTitle("Add Person")) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.white)
                            Text("Confirm")
                                .padding(.vertical)
                                .foregroundColor(.white)
                        }
                        .frame(width: 160)
                        .background(Color(red: 135/255, green: 167/255, blue: 156/255))
                        .cornerRadius(10)
                        
                    }
                }
                .padding(.vertical,20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.81, green: 0.87, blue: 0.80))
            .navigationBarBackButtonHidden(true)
            .font(.system(size: 15))
            .onAppear(){
                itemInputs.removeAll(where: { $0.hasilKali.isEmpty })
            }
    }
    
}


