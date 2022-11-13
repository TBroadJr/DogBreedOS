//
//  DogBreedOSApp.swift
//  DogBreedOS
//
//  Created by Tornelius Broadwater, Jr on 11/10/22.
//

import SwiftUI

@main
struct DogBreedOSApp: App {
    @StateObject private var manager = Manager()
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(Manager())
        }
    }
}
