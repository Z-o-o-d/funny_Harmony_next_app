//
//  ContentView.swift
//  harmonyNEXT
//
//  Created by 何金泽 on 2024/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        HStack {
            VStack {
                Image("HarmonyOSNEXT")
                    .resizable()
                    .scaledToFit()
                    

                
                    
                    

                Text("Powered By HarmonyOS NEXT")
                    .font(.footnote)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
