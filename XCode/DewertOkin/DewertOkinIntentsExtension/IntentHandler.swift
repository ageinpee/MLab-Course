//
//  IntentHandler.swift
//  DewertOkinIntentsExtension
//
//  Created by Nima Rahrakhshan on 25.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    func handle(startWorkout intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        
        let userActivity: NSUserActivity? = nil // What is the user currently doing? (Background)
        guard let spokenPhrase = intent.workoutName?.spokenPhrase else {
            completion(INStartWorkoutIntentResponse(code: .failureNoMatchingWorkout, userActivity: userActivity))
            return
        }
        
        completion(INStartWorkoutIntentResponse(code: .continueInApp, userActivity: userActivity))
    }
    
    func handle(endWorkout intent: INEndWorkoutIntent, completion: @escaping (INEndWorkoutIntentResponse) -> Void) {
        
    }
}
