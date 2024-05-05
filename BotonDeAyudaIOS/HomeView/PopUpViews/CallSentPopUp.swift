//
//  SuccessfulPopUp.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import SwiftUI

struct CallSentPopUp: View {
    @Binding var showSuccess: Bool
    @Binding var showCallPopUp: Bool
    @Binding var isSuccess: Bool
    
    @State var change: Bool = false
    @State var offset: CGFloat = 1000.0
    @State var counter: Int = 0
    
    var body: some View {
        
        ZStack{
            Color.black.opacity(0.3)
            
            VStack(spacing: 10){
                Text(isSuccess ? "Call sent succesfully" : "Call Cancelled")
                    .font(.headline)
                    .fontWeight(.bold)
                
                if isSuccess{
                    Image(systemName: change ? "dot.radiowaves.forward" : "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .symbolEffect(.bounce,value: counter)
                        .contentTransition(.symbolEffect(.replace.wholeSymbol))
                        .foregroundStyle(Color.green)
                    //                .animation(.bouncy, value: change)
                } else{
                    Image(systemName: "x.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .symbolEffect(.bounce, options: .repeat(1),value: counter)
                        .foregroundStyle(Color.red)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10)
            )
        }
        .ignoresSafeArea()
        .offset(x: 0, y: offset)
        .onAppear {
            
            offset = 0
            // Start a timer to toggle the value of `change` every 3 seconds
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                withAnimation(.bouncy(duration: 0.5, extraBounce: 0.5)){
                    change = true // Toggle the value of `change`
                    counter += 1
                }
                if counter > 3{
                    timer.invalidate() // Stop the current timer
                    withAnimation(.spring(duration: 0.5)){
                        offset = 1000           //Drop the view
                        showSuccess = false     //Hide success View
                        showCallPopUp = false   //Hide Call View
                        counter = 0             //Restart counter
                    }
                }
            }
        }
    }
}

#Preview {
    HomePage()
        .environmentObject(UserID())
}
