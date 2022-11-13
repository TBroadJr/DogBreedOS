//
//  Manager.swift
//  DogBreedOS
//
//  Created by Tornelius Broadwater, Jr on 11/10/22.
//

import SwiftUI
import CoreML
import Vision

@MainActor
class Manager: ObservableObject {
    @Published var dogImage = UIImage(systemName: "photo")
    @Published var breedData = BreedData(name: "", temperament: "", lifeSpan: "", bredFor: "", breedGroup: "", weight: Dimension(imperial: ""), height: Dimension(imperial: ""))
    
    @Published var startBreedRetrieval = false
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
        
    // MARK: - Breed API Call
    func getBreedData(dogBreed: String) async {
        guard let url = URL(string: "https://api.thedogapi.com/v1/breeds/search?api_key=live_CHvoq8ogDwP9AqGInCTQZc4XF2OHW0DJ874onzcVOLitw84dUOuzwJ0PJXIQ4Uh8&q=\(dogBreed)") else {
            showError(errorType: .urlError)
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let breedInfo = try JSONDecoder().decode([BreedData].self, from: data)
            if let info = breedInfo.first {
                breedData = info
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - CoreML Function
    func getBreedName() async {
        do {
            guard let myImage = dogImage?.cgImage else {
                showError(errorType: .imageError)
                return
            }
            let config = MLModelConfiguration()
            let model = try DogBreedClassifier(configuration: config)
            let input = try DogBreedClassifierInput(imageWith: myImage)
            let result = try model.prediction(input: input)
            await checkResult(result: result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Check Result
    private func checkResult(result: DogBreedClassifierOutput) async {
        guard let predictionPercentage = result.classLabelProbs[result.classLabel] else {
            showError(errorType: .predictionPercentageError)
            return
        }
                
        guard predictionPercentage > 0.90 else {
            showError(errorType: .lowPredictionPercentage)
            return
        }
        
        switch result.classLabel {
        case "Rottweiler": await getBreedData(dogBreed: "Rottweiler")
        case "German Shepherd": await getBreedData(dogBreed: "German_Shepherd")
        case "Labrador Retriever": await getBreedData(dogBreed: "Labrador_Retriever")
        case "Golden Retriever": await getBreedData(dogBreed: "Golden_Retriever")
        case "French Bulldog": await getBreedData(dogBreed: "French_Bulldog")
        default: break
        }
        
    }
    
    // MARK: - Display Error
    private func showError(errorType: CustomError) {
        showAlert = true
        alertTitle = errorType.errorTitle
        alertMessage = errorType.errorMessage
    }
}
