//
//  InfoView.swift
//  DogBreedOS
//
//  Created by Tornelius Broadwater, Jr on 11/10/22.
//

import SwiftUI

struct InfoView: View {
    // MARK: - Properties
    @EnvironmentObject var manager: Manager
    @State private var showImagePicker = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                screenBackground
                List {
                    imageSection
                    infoSection
                }
                .alert(manager.alertTitle, isPresented: $manager.showAlert) {
                    Button("Dismiss", role: .cancel) { }
                } message: {
                    Text(manager.alertMessage)
                }
                .sheet(isPresented: $showImagePicker, onDismiss: {
                    manager.startBreedRetrieval.toggle()
                }, content: {
                    PhotoPicker(dogImage: $manager.dogImage)
                        .ignoresSafeArea(edges: .bottom)
                })
                .onChange(of: manager.startBreedRetrieval) { newValue in
                    getInfo()
                }
                
            }
            .navigationTitle("DogBreedOS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showImagePicker = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// MARK: - InfoView Extension
private extension InfoView {
    // MARK: - Screen Background
    var screenBackground: some View {
        Color("Background")
            .ignoresSafeArea()
    }
    
    // MARK: - Image Section
    var imageSection: some View {
        Section("Image") {
            Image(uiImage: manager.dogImage!)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 250)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 10)
        }
    }
    
    // MARK: - Info Section
    var infoSection: some View {
        Section("Info") {
            Text("Name: \(manager.breedData.name)")
            Text("Breed Group: \(manager.breedData.breedGroup)")
            Text("Bred For: \(manager.breedData.bredFor)")
            Text("Temprament: \(manager.breedData.temperament)")
            Text("Life Span: \(manager.breedData.lifeSpan) years")
            Text("Height: \(manager.breedData.height.imperial) in.")
            Text("Weight: \(manager.breedData.weight.imperial) lbs.")
        }
    }
    
}

// MARK: - InfoView Function Extension
private extension InfoView {
    
    // MARK: - Get Info
    func getInfo() {
        Task {
            await manager.getBreedName()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .environmentObject(Manager())
    }
}
