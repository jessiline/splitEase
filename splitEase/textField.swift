//
//  textField.swift
//  splitEase
//
//  Created by jessiline imanuela on 26/04/24.
//
import SwiftUI

struct textField: View {
    @Binding var itemName: String
    @Binding var price: String
    @Binding var qty: String
    @Binding var hasilKali: String

    var body: some View {
        HStack{
            TextField("Item's Name", text: $itemName)
                .padding(.vertical,7) // Add padding to the TextField
                .padding(.leading,30)
                .background(Color.clear)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .padding(.leading,18)

                )
            Button(action: {
                // Action to toggle the visibility of the menu
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.black)
                    .padding(.trailing,15)
            }
        }
        .padding(.vertical)
        HStack{
            TextField("Price", text: $price)
                .frame(width: 87)
                .padding(.vertical,7) // Add padding to the TextField
                .padding(.leading,30)
                .background(Color.clear)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .padding(.leading,18)

                )
            Spacer()
            TextField("Qty", text: $qty)
                .frame(width: 32)
                .padding(.vertical,7) // Add padding to the TextField
                .padding(.leading,5)
                .background(Color.clear)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
//                                .padding(.leading,18)
//                                .padding(.trailing,40)

                )
                .frame(width: 50)
            Spacer()
            TextField("", text: $hasilKali)
                .frame(width: 80)
                .padding(.vertical,7) // Add padding to the TextField
                .padding(.trailing,30)
                .background(Color.clear)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .padding(.trailing,18)
                    

                )
                .multilineTextAlignment(.trailing)
        }
    }
}

