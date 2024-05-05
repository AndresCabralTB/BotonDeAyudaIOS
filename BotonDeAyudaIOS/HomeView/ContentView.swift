//
//  ContentView.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/04/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    // Environment object to access the user ID
    @EnvironmentObject var userID: UserID
    
    // View model for user data
    @StateObject var userViewModel = ContactViewModel()
    
    // State variables
    @State var user: MainUser = MainUser(userID: "", name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", heartRate: 0)
    @State var progress: Double = 0.0
    @State var blur: Int = 0
    @State var showPopUp: Bool = false
    @State var callStatus = CallStatus(success: 0, cancelled: 0)
    @State var showCallPopUp: Bool = false

    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    VStack{
                        HStack{
                            // Circular progress view
                            CircularProgressView(progress: $progress)
                                .onTapGesture {
                                    // Show pop-up view with animation
                                    withAnimation(.spring(duration: 0.5)){
                                        showPopUp = true
                                    }
                                }
                            
                            // Bar chart
                            BarMarkChart(callStatus: callStatus)
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                        .frame(maxWidth: .infinity)
                        
                        // Nearest hospital view
                        NearestHospital()
                        
                        // Button to initiate emergency call
                        Button{
                            // Show call pop-up view with animation
                            withAnimation(.spring(duration: 0.5)){
                                showCallPopUp = true
                            }
                        }label:{
                            Text("Press in case of an emergency")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                                .padding()
                                .frame(height: UIScreen.main.bounds.height * 0.1)
                                .frame(maxWidth: .infinity)
                            
                        }
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.green))
                        .shadow(radius: 10)
                        
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
   
                }
                
                // Pop-up view for successful call
                if showPopUp{
                    PopUpView(showPopUp: $showPopUp, progress: progress)
                        .toolbar(.hidden, for: .tabBar) // Hide toolbar items when pop-up is shown
                }
                
                // Pop-up view for emergency call
                if showCallPopUp{
                    CallPopUp(showCallPopUp: $showCallPopUp)
                        .toolbar(.hidden, for: .tabBar) // Hide toolbar items when pop-up is shown
                }
                
            }
    
            .navigationTitle("Emergency Button")
            // Hide navigation bar and tab items if any of the pop-up views are activated
            .toolbar(showPopUp || showCallPopUp ? .hidden : .visible, for: .tabBar, .navigationBar)
            
        }
        
        .onAppear{
            // Load user data when view appears
            loadUserData()
        }
    }
    
    // Function to load user data
    func loadUserData(){
        Task{
            do{
                // Fetch user data using view model
                user = try await userViewModel.getUser(userID: userID.userID)
                callStatus = try await userViewModel.getCallStatus(userID: user.userID)
            }
        }
        // Send notification to update barmark chart
        DataManager.shared.reloadBarMark()
    }
}

// Preview for ContentView
#Preview {
    // Initialize ContentView with UserID environment object
    HomePage()
        .environmentObject(UserID())
}
