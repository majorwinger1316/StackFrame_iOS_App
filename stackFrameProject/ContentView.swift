//
//  ContentView.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import SwiftUI

struct ContentView: View {
    @Namespace private var animationNamespace
    @State private var isCardTapped = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                CardView(isTapped: $isCardTapped, animationNamespace: animationNamespace)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8)) {
                            isCardTapped.toggle()
                        }
                    }
            }
        }
        .sheet(isPresented: $isCardTapped) {
            ExpandedView(animationNamespace: animationNamespace)
                .background(BackgroundBlurView())
        }
    }
}


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
