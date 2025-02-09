//
//  openStateView.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import Foundation
import SwiftUI

struct CircularSlider: View {
    @Binding var value: Double
    let minValue: Double
    let maxValue: Double
    let steps: Double
    
    @State private var angle: Double = 0
    @State private var isEditing = false
    @State private var previousAngle: Double = 0
    
    private let strokeWidth: CGFloat = 30
    private let diameter: CGFloat = 300
    
    init(value: Binding<Double>, in range: ClosedRange<Double>, step: Double = 100) {
        self._value = value
        self.minValue = range.lowerBound
        self.maxValue = range.upperBound
        self.steps = step
        
        let initialValue = value.wrappedValue
        let initialPercentage = (initialValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        self._angle = State(initialValue: initialPercentage * 360)
        self._previousAngle = State(initialValue: initialPercentage * 360)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: strokeWidth)

                Circle()
                    .trim(from: 0, to: angle / 360)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.indigo, .pink, .indigo]),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .shadow(radius: isEditing ? 10 : 5)
                    .offset(y: -diameter/2)
                    .rotationEffect(.degrees(angle))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                isEditing = true
                                let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                                let dragPosition = value.location
                                let dx = dragPosition.x - center.x
                                let dy = dragPosition.y - center.y
                                var currentAngle = atan2(dy, dx) * 180 / .pi + 90
  
                                if currentAngle < 0 {
                                    currentAngle += 360
                                }
            
                                var angleDelta = currentAngle - previousAngle
                            
                                if angleDelta > 180 {
                                    angleDelta -= 360
                                } else if angleDelta < -180 {
                                    angleDelta += 360
                                }
                                
                                let newAngle = angle + angleDelta
                                let newPercentage = newAngle / 360
                                let newValue = ((maxValue - minValue) * newPercentage + minValue).rounded(steps: steps)
                                
                                if newValue >= minValue && newValue <= maxValue {
                                    angle = newAngle
                                    self.value = newValue
                                }
                                
                                previousAngle = currentAngle
                            }
                            .onEnded { _ in
                                isEditing = false
                            }
                    )
                
                VStack(spacing: 8) {
                    Text("Selected Amount")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("₹\(Int(value))")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                    Text("@1.04% monthly")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: diameter, height: diameter)
        }
        .frame(width: diameter, height: diameter)
    }
}

extension Double {
    func rounded(steps: Double) -> Double {
        return (self / steps).rounded() * steps
    }
}

struct OpenStateView: View {
    let openStateDetails: Body
    @Binding var isModalPresented: Bool
    @State private var selectedAmount: Double = 500
    @State private var showEMIModal: Bool = false
    @State private var showBankAccountModal: Bool = false
    @State private var isCollapsed: Bool = false
    @State private var ctaText: String = "Select EMI Plan"
    @State private var emiPlans: [ItemDetail] = []
    @State private var bankAccounts: [ItemDetail] = []
    @State private var selectedBankAccount: ItemDetail? = nil
    @State private var selectedEMIPlan: ItemDetail? = nil

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(showEMIModal || showBankAccountModal ? 0.5 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        showEMIModal = false
                        showBankAccountModal = false
                    }
                }

            VStack {
                if !isCollapsed {
                    // Expanded View
                    VStack(spacing: 10) {
                        if let title = openStateDetails.title {
                            Text(title)
                                .font(.title2)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        if let subtitle = openStateDetails.subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        CircularSlider(value: $selectedAmount, in: 500...487891)
                            .padding(.vertical, 30)
                            .padding(.top, 30)

                        if let footer = openStateDetails.footer {
                            Text(footer)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()

                    Button(action: {
                        withAnimation {
                            isCollapsed = true
                            showEMIModal = true
                        }
                    }) {
                        Text(ctaText)
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
            }
            .background(Color.black.opacity(0.6))
            .cornerRadius(15)
            .padding()
            .shadow(radius: 10)
        }
        .onAppear {
            fetchData()
        }
        .overlay(
            Group {
                if showEMIModal {
                    EMIModalView(emiPlans: emiPlans, showBankAccountModal: $showBankAccountModal, selectedEMIPlan: $selectedEMIPlan)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                }

                if showBankAccountModal {
                    BankAccountModalView(bankAccounts: bankAccounts, isPresented: $showBankAccountModal, selectedBankAccount: $selectedBankAccount, selectedAmount: $selectedAmount, selectedEMIPlan: $selectedEMIPlan)
                        .transition(.move(edge: .bottom))
                        .zIndex(2)
                }

                if isCollapsed {
                    VStack {
                        HStack {
                            Text("Selected Amount:")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text("₹\(Int(selectedAmount))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation {
                                showEMIModal = false
                                showBankAccountModal = false
                                isCollapsed = false
                            }
                        }
                        
                        Spacer()
                    }
                    .transition(.move(edge: .top))
                    .zIndex(3)
                }
            }
            .animation(.easeInOut, value: showEMIModal)
        )
    }
    
    private func fetchData() {
        APIService.shared.fetchData { apiResponse in
            if let ctaText = apiResponse?.items.first?.cta_text {
                self.ctaText = ctaText
            }

            if let emiPlans = apiResponse?.items.first(where: { $0.open_state?.body?.items != nil })?.open_state?.body?.items {
                self.emiPlans = emiPlans
            }

            if let bankAccounts = apiResponse?.items.first(where: { $0.open_state?.body?.title == "where should we send the money?" })?.open_state?.body?.items {
                self.bankAccounts = bankAccounts
            }
        }
    }
}
