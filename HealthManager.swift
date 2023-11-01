//
//  HealthManager.swift
//  BeHealthly
//
//  Created by Jason Dubon on 11/1/23.
//

import Foundation
import HealthKit

class HealthManager {
    
    static let shared = HealthManager()
    
    private let healthStore = HKHealthStore()
    
    private init() { }
    
    func requestAccessToHealthData() async throws {
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        
        let healthTypes: Set = [steps, workouts]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func fetchTotalStepCountFrom(startDate: Date) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            fetchTotalStepCountFrom(startDate: startDate) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    private func fetchTotalStepCountFrom(startDate: Date, completion: @escaping (Result<Int, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: .now)
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                completion(.failure(URLError.notConnectedToInternet as! Error))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            completion(.success(Int(steps)))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTotalStepCountWithDateFrom(startDate: Date, completion: @escaping (Result<Int, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { _, results, error in
            guard let results = results, error == nil else {
                print("error with results")
                completion(.failure(URLError.notConnectedToInternet as! Error))
                return
            }
            
            results.enumerateStatistics(from: startDate, to: .now) { statistics, _ in
                print("Date: ", statistics.startDate ," Total Step Count: ", statistics.sumQuantity())
            }
            
            completion(.success(99))
        }
        
        healthStore.execute(query)
        
    }
}
