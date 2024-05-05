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
    
    var newTax: Int {
        if !tax.isEmpty && tax != "0" {
            if let taxInt = Int(tax.replacingOccurrences(of: ".", with: "")) {
                return taxInt / selectedOptionStates.keys.count
            }
        }
        return 0
    }
    var newServiceCharge: Int {
        if !serviceCharge.isEmpty && serviceCharge != "0" {
            if let serviceChargeInt = Int(serviceCharge.replacingOccurrences(of: ".", with: "")) {
                return serviceChargeInt / selectedOptionStates.keys.count
            }
        }
        return 0
    }
    
    var newDiscountBawah: Int {
        if !discountBawah.isEmpty && discountBawah != "0" {
            if let discountBawahInt = Int(discountBawah.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "")) {
                return discountBawahInt / selectedOptionStates.keys.count
            }
        }
        return 0
    }
    
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
                
                HStack{
                    Text("Total: \(totalAmount)")
                        .padding(.leading, 18)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.top,5)
                Text("_____________________________________________")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
                
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
                            
                            let tott = totalPerPerson + (newTax + newServiceCharge - newDiscountBawah)
                            Text("\(tott)")
                                .padding(.trailing, 18)
                            
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
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
                                                    .foregroundStyle(.gray)
                                                Spacer()
                                                Text("-\(diskonFinal)")
                                                    .padding(.trailing, 18)
                                                    .foregroundStyle(.green)
                                            }
                                        }
                                    } else {
                                        HStack {
                                            Text("item's discount")
                                                .padding(.leading, 30)
                                                .foregroundStyle(.gray)
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
                        
                       
                        HStack {
                            Text("Tax")
                                .padding(.leading, 30)
                                .foregroundStyle(.gray)
                            Spacer()
                            Text("+\(newTax)")
                                .padding(.trailing, 18)
                                .foregroundStyle(.green)
                        }
                        HStack {
                            Text("Service charge")
                                .padding(.leading, 30)
                                .foregroundStyle(.gray)
                            Spacer()
                            Text("+\(newServiceCharge)")
                                .padding(.trailing, 18)
                                .foregroundStyle(.green)
                        }
                        HStack {
                            Text("Discounts")
                                .padding(.leading, 30)
                                .foregroundStyle(.gray)
                            Spacer()
                            Text("-\(newDiscountBawah)")
                                .padding(.trailing, 18)
                                .foregroundStyle(.green)
                        }
                            
                    }
                    Text("----------------------------------------------------")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.bottom,10)
                        .padding(.top,5)

                }

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
