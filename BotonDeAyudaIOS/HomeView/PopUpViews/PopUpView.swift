//
//  PopUpView.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import SwiftUI

struct PopUpView: View{
    @Binding var showPopUp: Bool
    @State private var offset: CGFloat = 1000
    @State private var newOffset: CGFloat = 100
    @State var animate = false
    @State var progress: Double

    var body: some View{
        ZStack{
            Color.black.opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack(spacing: 20){
                Text(progress < 0.81 ? "You're in good health, keep it up!" : "Go see a doctor as soon as possible")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Image(systemName: progress < 0.81 ? "hand.thumbsup.fill" : "exclamationmark.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(progress < 0.81 ? Color.green : Color.red)
                    .frame(width: 70)
                    .symbolEffect(.bounce.up, options: .repeating.speed(0.2), value: offset)
            }
            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.25)
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
            .overlay(alignment: .topTrailing){
                Image(systemName: "x.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .padding()
                    .onTapGesture {
                        close()
                    }
                
            }
            .offset(x: 0, y: offset)
            .task{
                withAnimation(.spring(duration: 0.5)){
                    offset = 0
                }
            }
        }
        .ignoresSafeArea(.all)
    }
    
    func close(){
        withAnimation(.spring(duration: 0.5)){
            offset = 1000
            showPopUp = false
            print("ShowPopUp: \(showPopUp)")
            

        }
    }
    
    func bounceAnimation() {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
//                offset = -20 // Set the initial bounce position
            }
        }
}

#Preview {
    PopUpView(showPopUp: Binding.constant(false), progress: 0.3)
}
