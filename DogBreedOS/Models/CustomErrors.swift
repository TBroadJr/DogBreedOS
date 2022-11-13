//
//  CustomErrors.swift
//  DogBreedOS
//
//  Created by Tornelius Broadwater, Jr on 11/13/22.
//

import SwiftUI

enum CustomError {
    case urlError
    case imageError
    case predictionPercentageError
    case lowPredictionPercentage
    
    var errorTitle: String {
        switch self {
        case .urlError: return "URL Error"
        case .imageError: return "Image Error"
        case .predictionPercentageError, .lowPredictionPercentage: return "Prediction Error"
        }
    }
    
    var errorMessage: String {
        switch self {
        case .urlError: return "Error Creating URL"
        case .imageError: return "Error Getting Image"
        case .predictionPercentageError: return "Error Getting Prediction Strength Percentage"
        case .lowPredictionPercentage: return "Model is not sure about this image."
        }
    }
}
