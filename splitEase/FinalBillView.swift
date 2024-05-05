//
//  FinalBillView.swift
//  splitEase
//
//  Created by jessiline imanuela on 01/05/24.
//

import SwiftUI
struct FinalBillView: View {
    @Binding var selectedOptionStates: [String: [ItemInputState]]
    @Binding var subtotal: String
    @Binding var serviceCharge: String
    @Binding var tax: String
    @Binding var discountBawah: String
    @Binding var totalAmount: String
    var body: some View {
        VStack {
            Text("")
                .padding(.bottom, 5)
            ScrollView {
                Text("")

                // Dictionary to store the count of each item
                let itemCounts = selectedOptionStates.flatMap { $0.value }
                    .filter { $0.isChecked && Int($0.itemInput.qty) == 1 }
                    .reduce(into: [:]) { counts, state in
                        counts[state.itemInput.itemName, default: 0] += 1
                    }
                
                // Iterate through selectedOptionStates
                ForEach(selectedOptionStates.sorted(by: { $0.key < $1.key }), id: \.key) { (person, states) in
                    
                    VStack(alignment: .leading) {
                        HStack{
                            Text("\(person)'s total")

                            Spacer()
                            let totalPerPerson = states.reduce(0) { result, state in
                            if state.isChecked {
                                if !state.newDiscount.isEmpty {
                                    if let newHasilKaliNumeric = Int(state.newHasilKali.replacingOccurrences(of: ".", with: "")), let newHasildiskon = Int(state.newDiscount.replacingOccurrences(of: ".", with: "")), let count = itemCounts[state.itemInput.itemName], count > 1 {
                                        if count != 0 {
                                            return result + (newHasilKaliNumeric / count) - (newHasildiskon/count)
                                        }
                                    }
                                    else{
                                        if let newHasilKaliNumeric = Int(state.newHasilKali.replacingOccurrences(of: ".", with: "")),
                                           let newDiscountNumeric = Int(state.newDiscount.replacingOccurrences(of: ".", with: "")) {
                                            return result + newHasilKaliNumeric - newDiscountNumeric
                                        }
                                    }
                                }
                                else{
                                    if let newHasilKaliNumeric = Int(state.newHasilKali.replacingOccurrences(of: ".", with: "")),
                                       let count = itemCounts[state.itemInput.itemName], count > 1 {
                                        if count != 0 {
                                            return result + (newHasilKaliNumeric / count)
                                        }
                                    } else {
                                        if let newHasilKaliNumeric = Int(state.newHasilKali.replacingOccurrences(of: ".", with: "")) {
                                            return result + newHasilKaliNumeric
                                        }
                                    }
                                }
                            }
                            return result
                        }
                        Text("\(totalPerPerson)")
                            .padding(.trailing, 18)
                        }
                        .font(.headline)
                        .padding(.bottom)
                        .padding(.leading)
                        
                        // Filter checked items
                        let filteredStates = states.filter { $0.isChecked }
                        
                        ForEach(filteredStates, id: \.self) { state in
                            VStack {
                                HStack {
                                    Text("\(state.itemInput.itemName)")
                                        .padding(.leading, 18)
                                    Spacer()
                                }
                                HStack {
                                    Text("\(state.itemInput.price)")
                                        .padding(.leading, 18)
                                        .foregroundStyle(.gray)
                                        .frame(width: 140, alignment: .leading)
                                    
                                    Spacer()
                                    Text("\(state.qty) x")
                                        .foregroundStyle(.gray)
                                        .frame(width: 50, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    // Calculate hasilFinal only if qty == 1 and count > 1
                                    if Int(state.itemInput.qty) == 1, let count = itemCounts[state.itemInput.itemName], count > 1 {
                                        if let newHasilKaliNumeric = Int(state.newHasilKali.replacingOccurrences(of: ".", with: "")) {
                                            let hasilFinal = newHasilKaliNumeric / Int(count)
                                            Text("\(hasilFinal)")
                                                .padding(.trailing, 18)
                                                .frame(width: 105, alignment: .trailing)
                                        }
                                    } else {
                                        Text("\(state.newHasilKali)")
                                            .padding(.trailing, 18)
                                            .frame(width: 105, alignment: .trailing)
                                    }
                                }
                                .padding(.vertical, 5)
                                
                                if !state.newDiscount.isEmpty {
                                    if Int(state.itemInput.qty) == 1, let count = itemCounts[state.itemInput.itemName], count > 1 {
                                        if let newHasildiskon = Int(state.newDiscount.replacingOccurrences(of: ".", with: "")) {
                                            let diskonFinal = newHasildiskon / Int(count)
                                            HStack {
                                                Text("Discounts")
                                                    .padding(.leading, 30)
                                                    .foregroundStyle(.gray) // Set foreground color
                                                Spacer()
                                                Text("-\(diskonFinal)")
                                                    .padding(.trailing, 18)
                                                    .foregroundStyle(.green)
                                            }
                                        }
                                    } else {
                                        HStack {
                                            Text("Discounts")
                                                .padding(.leading, 30)
                                                .foregroundStyle(.gray) // Set foreground color
                                            Spacer()
                                            Text("-\(state.newDiscount)")
                                                .padding(.trailing, 18)
                                                .foregroundStyle(.green)
                                        }
                                    }
                                    
                                }
                            }
                            .padding(.bottom)

                        }
                    }
                    Text("----------------------------------------------------")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.bottom,10)
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
                .padding(.bottom,20)

            }
            .frame(width: 333)
            .background(Color(red: 1, green: 0.99, blue: 0.91))
            .cornerRadius(10)
            .font(.callout)
            
            NavigationLink(destination: MainPageView()) {
                HStack {
                    Text("Done")
                        .frame(width: 333)
                        .padding(.vertical)
                        .foregroundColor(.white)
                }
                .background(Color(red: 135/255, green: 167/255, blue: 156/255))
                .cornerRadius(10)
                
            }
            .padding(.vertical,20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.81, green: 0.87, blue: 0.80))
    }
}
