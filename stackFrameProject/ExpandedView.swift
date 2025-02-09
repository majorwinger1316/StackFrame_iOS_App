//
//  ExpandedView.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import SwiftUI

struct ExpandedView: View {
    var animationNamespace: Namespace.ID
    @State private var isModalPresented = false
    @State private var buttonText: String = "Credit Amount"
    @State private var isLoading: Bool = true
    @State private var openStateDetails: Body?
    
    var body: some View {
        ZStack {
            Image("creditim")
                .resizable()
                .scaledToFill()
                .matchedGeometryEffect(id: "card", in: animationNamespace)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                        .mask(
                            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        )
                        .ignoresSafeArea()
                )

            VStack {
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else {
                    Button(action: {
                        isModalPresented.toggle()
                    }) {
                        Text(buttonText)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: 350)
                            .foregroundColor(.white)
                            .background(Color.indigo)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color.black.opacity(0.4))
        .sheet(isPresented: $isModalPresented) {
            if let openStateDetails = openStateDetails {
                OpenStateView(openStateDetails: openStateDetails, isModalPresented: $isModalPresented)
            }
        }
        .onAppear {
            fetchButtonText()
        }
    }
    
    private func fetchButtonText() {
        guard let url = URL(string: "https://api.mocklets.com/p6764/test_mint") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)

                DispatchQueue.main.async {
                    if let firstItem = apiResponse.items.first {
                        buttonText = firstItem.closed_state?.body?.key1 ?? "Credit Amount"
                        openStateDetails = firstItem.open_state?.body
                    }
                    isLoading = false
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
