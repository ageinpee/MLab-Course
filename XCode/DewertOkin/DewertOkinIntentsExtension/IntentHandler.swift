//
//  IntentHandler.swift
//  DewertOkinIntentsExtension
//
//  Created by Nima Rahrakhshan on 25.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any? {
        if intent is INStartWorkoutIntent {
            return StartWorkoutIntentHandler()
        }
        else if intent is INEndWorkoutIntent {
            return StopWorkoutIntentHandler()
        }
    }
    
}
