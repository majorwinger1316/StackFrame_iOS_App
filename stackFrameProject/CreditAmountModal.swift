//
//  CreditAmountModal.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import Foundation
import SwiftUI

struct CreditAmountModal: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Available Credit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("$5,000.00")
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(.green)
                
                Button(action: {}) {
                    Text("Close")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(15)
                }
                .padding(.top, 40)
            }
            .padding(40)
        }
    }
}

#Preview {
    CreditAmountModal()
}
