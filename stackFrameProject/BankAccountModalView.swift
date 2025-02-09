//
//  BankAccountModalView.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import Foundation
import SwiftUI

struct BankAccountModalView: View {
    let bankAccounts: [ItemDetail]
    @Binding var isPresented: Bool
    @Binding var selectedBankAccount: ItemDetail?
    @Binding var selectedAmount: Double
    @Binding var selectedEMIPlan: ItemDetail?

    var body: some View {
        VStack(spacing: 0) {

            Text("Where should we send the money?")
                .font(.title2)
                .fontWeight(.regular)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Amount will be credited to the bank account. EMI will also be debited from this bank account")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(bankAccounts) { account in
                        Button(action: {
                            selectedBankAccount = account
//                            isPresented = false
                        }) {
                            BankAccountCard(account: account, isSelected: selectedBankAccount?.id == account.id)
                        }
                    }
                }
                .padding()
            }

            Spacer()

            Button(action: {
                withAnimation {
                }
            }) {
                Text("Tap for 1-click KYC")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(Color.black.opacity(0.6))
        .cornerRadius(15)
        .padding()
        .padding(.top, 180)
        .shadow(radius: 10)
    }
}


struct BankAccountCard: View {
    let account: ItemDetail
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(account.title ?? "N/A")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(account.subtitle ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? Color.indigo.opacity(0.2) : Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.indigo : Color.clear, lineWidth: 2)
        )
    }
}
