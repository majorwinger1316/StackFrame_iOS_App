//
//  cardView.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import Foundation
import SwiftUI

struct CardView: View {
    @Binding var isTapped: Bool
    var animationNamespace: Namespace.ID
    
    var body: some View {
        ZStack {
            Image("creditim")
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .matchedGeometryEffect(id: "card", in: animationNamespace)
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                        .mask(
                            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        )
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text("Get Credit")
                    .font(.largeTitle.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.leading)
                Text("Earn Points")
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.bottom)
            }
        }
        .frame(height: 200)
        .padding(16)
        .shadow(radius: 10)
    }
}
