//
//  CircularProgressView.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import SwiftUI

struct CircularProgressView: View {
    // 1
    @EnvironmentObject var userID: UserID
    @StateObject var viewModel = ContactViewModel()
    @Binding var progress: Double
    @State var user = MainUser(userID: "", name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", heartRate: 0)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Heart Rate")
                .font(.headline)
                .fontWeight(.bold)
            
            
            ZStack {
                Circle()
                    .stroke(
                        Color(progress < 0.81 ? .green : .red).opacity(0.5),
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round
                        )
                        
                    )
                    .rotationEffect(.degrees(90))
                
                Circle()
                // Adjust the "to" value to control how much of the circle is filled
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color(progress < 0.81 ? .green : .red),
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round
                        )
                        
                    )
                    //Animate the progress var value with a duration
                    .animation(.easeIn(duration: 0.5), value: progress)
                    .rotationEffect(.degrees(90))
                
                Text("\(progress * 100, specifier: "%.0f") bmp")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding(10)
            .frame(maxHeight: .infinity)
            
//            Slider(value: $progress, in: 0...1)
        }
        .padding(10)
        .frame(maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
        
        .onAppear{
            progress = 0.0
            Task{
                do{
                    user = try await viewModel.getUser(userID: userID.userID)
                    withAnimation(.easeIn(duration: 0.1)){ //Make the change change with an animation
//                        progress = 0.8
                        progress = CGFloat(user.heartRate) / 100.0
                        print("Graph: \(progress)")
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
