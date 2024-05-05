//
//  CallPopUp.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import SwiftUI

struct CallPopUp: View {
    
    @EnvironmentObject var userID: UserID
    
    @State var callStatus = CallStatus(success: 0, cancelled: 0)
    @State var viewModel = ContactViewModel()

    @State private var timeRemaining = 10
    @State var timeElapsed: Int = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var offset: CGFloat = 1000
    
    @State var showSuccess: Bool = false
    @State var isSuccess: Bool = false
    
    @Binding var showCallPopUp: Bool
    var body: some View {
        
        if showSuccess{
            CallSentPopUp(showSuccess: $showSuccess, showCallPopUp: $showCallPopUp, isSuccess: $isSuccess)
        } else{
            
            ZStack(alignment: .bottom){
                Color.black.opacity(0.5)
                VStack(spacing: 20){
                    Text("Are you sure you want to make the emergency call ?")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Image(systemName: "\(timeRemaining).circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55)
                        .fontWeight(.semibold)
                        .onReceive(timer) { time in //Start timer from 10 to 0
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            } else{
                                callStatus.success += 1
                                addData()
                                isSuccess = true
                                close()
                            }
                        }
                        .symbolEffect(.bounce.up, value: timeRemaining)
                        .foregroundStyle(getColor(time: timeRemaining))
                        .animation(.easeInOut, value: timeRemaining)
                    
                    HStack{
                        
                        Button{
                            //Cancel process and add value db
                            callStatus.cancelled += 1
                            addData()
                            close()
                        }label:{
                            Text("Cancel")
                                .foregroundStyle(Color.red)
                                .fontWeight(.bold)
                                .padding(10)
                                .frame(width: UIScreen.main.bounds.width * 0.75)
                                .background(RoundedRectangle(cornerRadius: 25).stroke(Color.red, lineWidth: 2).shadow(radius: 10))                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)))
                
            }
            .ignoresSafeArea()
            .offset(x: 0, y: offset)
            .onAppear{
                Task{
                    do{
                        callStatus = try await viewModel.getCallStatus(userID: userID.userID)
                        withAnimation(.spring(duration: 0.5)){
                            offset = 0
                        }
                    }
                }
            }
        }
    }
    
    func close(){
        withAnimation(.spring(duration: 0.5)){
            showSuccess = true
            offset = 1000
            timer.upstream.connect().cancel()

//            showCallPopUp = false
        }
    }
    
    func addData(){
        Task {
            do{
                try await viewModel.addCallStatus(userID: userID.userID, callStatus: callStatus)
            }
        }
        DataManager.shared.reloadBarMark() //Send notification to update barmark chart
    }
    
    func getColor(time: Int) -> Color{
        if time > 6{
            return Color.green
        } else if time > 3{
            return Color.yellow
        }else{
            return Color.red
        }
    }
}

#Preview {
    HomePage()
        .environmentObject(UserID())
}
