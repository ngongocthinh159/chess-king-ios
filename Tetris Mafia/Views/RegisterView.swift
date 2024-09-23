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

struct RegisterView: View {
    @Environment(ModelData.self) var modelData
    @Environment(SessionManager.self) var session
    
    @State var inputText: String = ""
    @State var inputErrorMessage: String?
    @State var selectedAvatar: Avatar = .dog
    @State private var isShowMenuView: Bool  = false 
    @State private var isRegistering: Bool  = false
    
    private let registerDelayTime = CGFloat(0.8)
    
    var body: some View {
        ZStack {
            BackgroundImage(image: modelData.appConfig.backgroundImageName)
            
            VStack(alignment: .leading, spacing: 48) {
                AvatarPickerView(selectedAvatar: $selectedAvatar)
                
                VStack(alignment: .trailing, spacing: modelData.appConfig.isIPhone ? 16 : 32) {
                    InputFieldWithBGImage(text: $inputText, 
                                          errorMessage: $inputErrorMessage,
                                          title: modelData.appConfig.getRegisterView_InputLabel_Text(),
                                          width: modelData.appConfig.isIPhone ? 300 : 500,
                                          placeHolder: modelData.appConfig.getRegisterView_InputPlaceHolder_Text())
                    
                    ImageButton(imageName: modelData.appConfig.registerButtonName, width: modelData.appConfig.isIPhone ? 180 : 220, isDisabled: $isRegistering) {
                        withAnimation {
                            register()
                        }
                    }
                    .disabled(isRegistering ? true : false)
                }
            }
        }
        .withHeader(title: modelData.appConfig.getRegisterView_PageHeader_Text())
        .navigationBarBackButtonHidden(true)
        
        // MARK: - Navigation
        .navigationDestination(isPresented: $isShowMenuView) {
            MenuView()
        }
    }
    
    // MARK: - register logic
    func register() {
        guard !inputText.isEmpty, !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            inputErrorMessage = modelData.appConfig.getRegisterView_Error_EmptyUsernam_Text()
            return
        }
        
        // check unique username
        let newUserName = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        for user in modelData.users {
            if (user.name.lowercased() == newUserName.lowercased()) {
                inputErrorMessage = "*\(modelData.appConfig.language == .EN ? "Username" : "Tài khoản") \(newUserName) \(modelData.appConfig.language == .EN ? "already existed!" : "đã tồn tại!")"
                return
            }   
        }
        
        // register and go to game menu
        isRegistering = true
        DispatchQueue.main.asyncAfter(deadline: .now() + registerDelayTime) {
            inputErrorMessage = nil
            session.register(userName: newUserName, avatar: selectedAvatar)
            
            isRegistering = false
            isShowMenuView = true
        }
    }
}

#Preview {
    RegisterView()
        .environment(ModelData.previewModelData)
        .environment(SessionManager.previewSession)
}
