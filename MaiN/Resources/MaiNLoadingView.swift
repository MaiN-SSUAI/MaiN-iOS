//
//  MaiNLoadingView.swift
//  MaiN
//
//  Created by 김수민 on 5/21/24.
//

import SwiftUI

struct MaiNLoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.pink)
                    .scaleEffect(1.2)
                    .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true))
                
                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(20)
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    MaiNLoadingView()
}
