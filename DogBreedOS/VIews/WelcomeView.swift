//
//  ContentView.swift
//  DogBreedOS
//
//  Created by Tornelius Broadwater, Jr on 11/10/22.
//

import SwiftUI

struct WelcomeView: View {
    
    // MARK: - Properties
    @EnvironmentObject var manager: Manager
    @State private var showImagePicker = false
    @State private var showInfoView = false
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Body
    var body: some View {
        ZStack {
            screenBackground
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    titleText
                    subtitleText
                }
                .padding()
                .strokeStyle(cornerRadius: 20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color("Shadow").opacity(0.5), radius: 5, x: 0, y: 5)
                addImageButton
            }
            .sheet(isPresented: $showImagePicker, onDismiss: {
                manager.startBreedRetrieval.toggle()
                showInfoView = true
            }, content: {
                PhotoPicker(dogImage: $manager.dogImage)
                    .ignoresSafeArea(edges: .bottom)
            })
            .fullScreenCover(isPresented: $showInfoView) {
                InfoView()
            }
            .onChange(of: manager.startBreedRetrieval) { newValue in
                getInfo()
            }
            
        }
    }
}

// MARK: - Welcom View Extension
private extension WelcomeView {
    
    // MARK: - Screen Background
    var screenBackground: some View {
        Color("Background").ignoresSafeArea()
    }
    
    // MARK: - Title Text
    var titleText: some View {
        Text("DogBreedOS")
            .font(.system(size: 40, weight: .bold, design: .serif))
    }
    
    // MARK: - Subtitle Text
    var subtitleText: some View {
        Text("Capture images of different dogs and retrieve basic and critical information about it's breed.")
            .font(.system(size: 20, weight: .semibold, design: .serif))
            .multilineTextAlignment(.center)
    }
    
    // MARK: - Add Image Button
    var addImageButton: some View {
        Button {
            showImagePicker = true
            generator.impactOccurred()
        } label: {
            Text("Add Image")
                .frame(maxWidth: .infinity)
        }
        .font(.headline)
        .blendMode(.hardLight)
        .buttonStyle(.angular)
        .tint(.accentColor)
        .controlSize(.large)
        .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
        .padding()
        .padding(.vertical, 20)
        
    }
}

// MARK: - WelcomeView Function Extension
extension WelcomeView {
    
    // MARK: - Get Info
    func getInfo() {
        Task {
            await manager.getBreedName()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(Manager())
    }
}
