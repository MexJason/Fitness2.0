//
//  ContentView.swift
//  BeHealthly
//
//  Created by Jason Dubon on 11/1/23.
//

import SwiftUI

struct ContentView: View {
    @State var today = 0
    @State var thisWeek = 0
    
    var body: some View {
        VStack {
            VStack {
                Text("This Week")
                
                Text("\(thisWeek) steps")
            }
            
            VStack {
                Text("Today")
                
                Text("\(today) steps")
            }
        }
        .padding()
        .task {
            do {
                try await HealthManager.shared.requestAccessToHealthData()
                today = try await HealthManager.shared.fetchTotalStepCountFrom(startDate: .startOfDay)
                thisWeek = try await HealthManager.shared.fetchTotalStepCountFrom(startDate: .startOfWeek)
                
                HealthManager.shared.fetchTotalStepCountWithDateFrom(startDate: .startOfWeek) { result in
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
