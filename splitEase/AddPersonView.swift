//
//  AddPersonView.swift
//  splitEase
//
//  Created by jessiline imanuela on 30/04/24.
//

import SwiftUI

struct AddPersonView: View {
    @Binding var names: [String]
    @FocusState private var isTextFieldFocused: Bool
    
//    @State private var subtotal: String = ""
//    @State private var serviceCharge: String = ""
//    @State private var tax: String = ""
//    @State private var discountBawah: String = ""
//    @State private var totalAmount: String = ""
//    @State private var itemInputs: [ItemInput] = [ItemInput()]
    @Binding var subtotal: String
    @Binding var serviceCharge: String
    @Binding var tax: String
    @Binding var discountBawah: String
    @Binding var totalAmount: String
    @Binding var itemInputs: [ItemInput]
    @State private var selectedOption: String?

    var body: some View {
        VStack{
            Text("")
                .padding(.bottom,5)
            ScrollView{
                Button(action: {
                    names.append("")
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .padding(.leading)
                        Text("Add Person")
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .padding(.top,30)
                    .padding(.bottom,25)
                    .padding(.leading,5)
                }
                
                // Tampilkan input nama untuk setiap nama dalam daftar
                ForEach(names.indices, id: \.self) { index in
                    HStack {
                        TextField("Name", text: $names[index])
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
                            names.remove(at: index)
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.black)
                                .padding(.trailing,15)
                        }
                    }
                    .padding(.bottom,10)
                    .focused($isTextFieldFocused)

                }
            }
            .frame(width: 333)
            .background(Color(red: 1, green: 0.99, blue: 0.91))
            .cornerRadius(10)
            .font(.callout)
            
            NavigationLink(destination: PickMenuView(names: $names, subtotal: $subtotal, serviceCharge: $serviceCharge, tax: $tax, discountBawah: $discountBawah, totalAmount: $totalAmount, itemInputs: $itemInputs).navigationBarTitle("Bill Details")) {
                    Text("Save")
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .frame(width: 333)
                        .background(Color(red: 135/255, green: 167/255, blue: 156/255))
                        .cornerRadius(10)
                
            }
            .opacity(isTextFieldFocused ? 0 : 1)
            .padding(.vertical, isTextFieldFocused ? -20 : 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.81, green: 0.87, blue: 0.80))
        .font(.system(size: 15))
    }
}

//struct AddPersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        let names = Binding.constant([""]) // Inisialisasi Binding untuk names
//        return AddPersonView(names: names)
//    }
//}
