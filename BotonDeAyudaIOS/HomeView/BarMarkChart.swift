//
//  BarMarkChart.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import SwiftUI
import Charts

class CallStatus: ObservableObject{
    @Published var success : Int
    @Published var cancelled: Int
    
    init(success: Int, cancelled: Int) {
        self.success = success
        self.cancelled = cancelled
    }
}

struct BarMarkChart: View {
    @EnvironmentObject var userID: UserID
    
    @StateObject var viewModel = ContactViewModel()
    @StateObject var dataManager = DataManager()
    
    @State var callStatus: CallStatus = CallStatus(success: 0, cancelled: 0)
    @State var rangeTop: Int = 0
    @State var success: Int = 0
    @State var cancelled: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            
            Text("Calls Status")
                .font(.headline)
                .fontWeight(.bold)

//            Divider()
            
            Chart {
                
                //No reason to optimize because only two BarMarks are used
                
                //BarMark for success times
                BarMark(x: .value("Type", "Success"),
                        y: .value("Population", success)) //Access the Integer but set to default values in case the fetched value is empty
                .clipShape(
                    .rect(
                        topLeadingRadius: 5,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 5
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 10))
                .foregroundStyle(.green)
                
                //BarMark for cancelled times
                BarMark(x: .value("Type", "Cancelled"),
                        y: .value("Population", cancelled))
                .clipShape(
                    .rect(
                        topLeadingRadius: 5,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 5
                    )
                )
                .foregroundStyle(.red)
            }
            .chartYScale(domain: 0...rangeTop)

            
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
        .onAppear{
            success = 0
            cancelled = 0
            rangeTop = 0
            
            loadCallStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("reloadBarMark"))) { _ in
            loadCallStatus()
        }

    }
    func loadCallStatus(){
        Task{
            do{
                callStatus = try await viewModel.getCallStatus(userID: userID.userID)
                withAnimation(.easeIn(duration: 1)){
                    success = callStatus.success
                    cancelled = callStatus.cancelled
                    rangeTop = getLargestNum(success: success, cancelled: cancelled)
                }
            }
        }
        
        print("BarMarkChart View: \(success)")

        
    }
    func getLargestNum(success: Int, cancelled: Int) -> Int{
        
        if success > cancelled{
            return success + 5
        } else{
            return cancelled + 5
        }
        
    }
}

#Preview {
    BarMarkChart(callStatus: CallStatus(success: 0, cancelled: 0))
        .environmentObject(UserID())
}
