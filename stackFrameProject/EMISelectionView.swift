//
//  EMISelectionView.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import Foundation
import SwiftUI

struct EMIModalView: View {
    let emiPlans: [ItemDetail]
    @Binding var showBankAccountModal: Bool
    @Binding var selectedEMIPlan: ItemDetail?
    @State private var isCollapsed: Bool = false

    var body: some View {
        VStack {
            if isCollapsed {
                VStack {
                    HStack {
                        Text("Selected EMI:")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text(selectedEMIPlan?.title ?? "N/A")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top, 80)
                    .onTapGesture {
                        withAnimation {
                            isCollapsed = false
                            showBankAccountModal = false
                        }
                    }
                    Spacer()
                }
                .transition(.move(edge: .top))
            } else {
                VStack(spacing: 0) {
                    Text("How do you wish to repay?")
                        .font(.title2)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Choose one of our recommended plans or make your own")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(emiPlans) { plan in
                                Button(action: {
                                    withAnimation {
                                        selectedEMIPlan = plan
                                    }
                                }) {
                                    EMIPlanCard(plan: plan, isSelected: selectedEMIPlan?.id == plan.id)
                                }
                            }
                        }
                        .padding()
                    }

                    Spacer()

                    Button(action: {
                        withAnimation {
                            isCollapsed = true
                            showBankAccountModal = true
                        }
                    }) {
                        Text("Select your bank account")
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
                .padding(.top, 60)
                .shadow(radius: 10)
            }
        }
    }
}

struct EMIPlanCard: View {
    let plan: ItemDetail
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(plan.title ?? "N/A")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if plan.tag == "recommended" {
                    Text("Recommended")
                        .font(.caption)
                        .padding(5)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(5)
                        .foregroundColor(.green)
                }
            }
            
            Text(plan.subtitle ?? "N/A")
                .font(.subheadline)
                .foregroundColor(.gray)
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
