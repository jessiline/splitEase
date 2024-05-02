//
//  ContentView.swift
//  splitEase
//
//  Created by jessiline imanuela on 23/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainPage = false
        
    var body: some View {
        Group {
            if showMainPage {
                MainPageView()
            } else {
                PreloadView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                self.showMainPage = true
                            }
                        }
                    }
            }
        }
    }
    
}
struct PreloadView: View {
    var body: some View {
        VStack {
            Image("logo")
               .resizable()
               .frame(width: 213, height: 143)
               .foregroundStyle(.tint)
            Image("logoText")
       }
       .frame(maxWidth: .infinity, maxHeight: .infinity)
       .background(Color(red: 255/255, green: 253/255, blue: 231/255))
    }
}
#Preview {
    ContentView()
}

