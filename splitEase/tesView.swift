//
//  coba.swift
//  BMIBuddy
//
//  Created by Vanessa on 30/04/24.
//

import SwiftUI
//enum Anchor {
//    case top, bottom
//}

struct tesView: View {
    @State private var value = 0
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.value -= 1
                }) {
                    Image(systemName: "minus")
                }
                Text("\(value)")
                    .padding()
                Button(action: {
                    self.value += 1
                }) {
                    Image(systemName: "plus")
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
        }
    }
    
            
       
    
        
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        tesView()
    }
}
