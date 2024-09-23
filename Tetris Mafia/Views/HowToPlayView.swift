/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Ngo Ngoc Thinh
  ID: s3879364
  Created  date: 26/08/2024
  Last modified: 02/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
     https://www.youtube.com/watch?v=Va1Xeq04YxU&t=15559s
     https://www.instructables.com/Playing-Chess/
     https://github.com/exyte/PopupView
     https://github.com/willdale/SwiftUICharts
*/

import SwiftUI
import Foundation

struct HowToPlayView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(ModelData.self) var data

    @State private var selectedStep = 0
    var steps: [HowToPlayStep]

    var body: some View {
        ZStack {
            GradientBackground()
                .ignoresSafeArea()

            TabView(selection: $selectedStep) {
                ForEach(steps.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text(steps[index].title)
                            .font(.custom(data.appConfig.appFontBlack, size: data.appConfig.stepHeaderFontSize))
                            .foregroundStyle(data.appConfig.textColorOnBG)
                            .padding(.bottom)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                
                                
                                ForEach(steps[index].images, id: \.self) { image in
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 600, maxHeight: data.appConfig.isIPhone ? 300 : 600)
                                }
                                
                                ForEach(steps[index].details, id: \.header) { detail in
                                    if !detail.header.isEmpty {
                                        Text(detail.header)
                                            .font(.custom(data.appConfig.appFontBold, size: data.appConfig.stepSectionTitleFontSize))
                                            .foregroundStyle(data.appConfig.textColorOnBG)
                                            .padding(.top)
                                    }
   
                                    ForEach(detail.content, id: \.self) { text in
                                        Text(text)
                                            .font(.custom(data.appConfig.appFontRegular, size: data.appConfig.stepNormalTextFontSize))
                                            .foregroundStyle(data.appConfig.textColorOnBG)
                                            .padding(.bottom, 5)
                                    }
                                }
                                
                            }
                            
                        }
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .tag(index)
                    }
                    .padding()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            // Navigation Buttons
            navigationButtons
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        
        // MARK: music
        .onAppear {
            AudioManager.shared.pauseAllMusics()
            AudioManager.shared.stopHTPMusic()
            AudioManager.shared.playHTPMusic(filename: data.appConfig.howToPlayMusic)
        }
    }

    var navigationButtons: some View {
        VStack {
            Spacer()
            HStack {
                // MARK: prev button
                Button(action: {
                    if selectedStep > 0 {
                        withAnimation {
                            selectedStep -= 1
                        }
                        
                        AudioManager.shared.playSoundEffect(filename: data.appConfig.profileButtonTapMusic)
                    }
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.largeTitle)
                }
                .buttonStyle(SolidButtonStyle(fillColor: selectedStep == 0 ? .gray : .blue))
                .disabled(selectedStep == 0)
                .accessibilityLabel("Previous Step")
                
                Spacer()
                
                // MARK: Home button
                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    AudioManager.shared.playSoundEffect(filename: data.appConfig.profileButtonTapMusic)
                }) {
                    Image(systemName: "house.fill")
                        .font(.largeTitle)
                }
                .buttonStyle(SolidButtonStyle(fillColor: .clear))
                .accessibilityLabel("Home")

                Spacer()
                    
                // MARK: Next button
                Button(action: {
                    if selectedStep < steps.count - 1 {
                        withAnimation {
                            selectedStep += 1
                        }
                        
                        AudioManager.shared.playSoundEffect(filename: data.appConfig.profileButtonTapMusic)
                    }
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.largeTitle)
                }
                .buttonStyle(SolidButtonStyle(fillColor: selectedStep == steps.count - 1 ? .gray : .blue))
                .disabled(selectedStep == steps.count - 1)
                .accessibilityLabel("Next Step")
            }
        }
        .padding()
        .padding(.bottom)
    }
}

struct SolidButtonStyle: ButtonStyle {
    var fillColor: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(fillColor)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(radius: 10)
    }
}

#Preview {
    HowToPlayView(steps: HowToPlayStep.staticStepsEnglish())
        .environment(ModelData.previewModelData)
}
