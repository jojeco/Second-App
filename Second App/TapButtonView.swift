//
//  TapButtonView.swift
//  Second App
//
//  The main tap target, extracted verbatim from ContentView.
//

import SwiftUI

struct TapButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Tap Me!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(width: 150, height: 150)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(75)
                .shadow(radius: 10)
        }
        .padding()
    }
}
