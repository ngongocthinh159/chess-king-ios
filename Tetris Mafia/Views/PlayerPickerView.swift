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

struct PlayerPickerView: View {
    @Environment(ModelData.self) var modelData
    @Environment(SessionManager.self) var session
    
    @State var selectedUserID: UUID?
    @State private var isLoginPushAtLeastOne = false
    @State private var isShowMenuView = false
    @State private var isShowRegisterView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage(image: modelData.appConfig.backgroundImageName)
                
                VStack {
                    GeneralTitle(title: modelData.appConfig.getPlayerPickerView_ChooseYouAccount_Text())
                    
                    PlayerListView(users: modelData.users, selectedUserID: $selectedUserID)
                    
                    if isLoginPushAtLeastOne && selectedUserID == nil  {
                        ErrorText(text: modelData.appConfig.getPlayerPickerView_Error_NotChosing_Text(),
                                  iphoneSize: 18,
                                  ipadSize: 28)
                            .padding(.top)
                    }
                    
                    VStack() {
                        ImageButton(imageName: modelData.appConfig.loginButtonName, width: modelData.appConfig.isIPhone ? 240 : 300) {
                            withAnimation {
                                isLoginPushAtLeastOne = true
                            }
                            
                            login()
                            
                            if selectedUserID != nil {
                                isShowMenuView = true
                            }
                        }
                        
                        ImageButton(imageName: modelData.appConfig.signupButtonName, width: modelData.appConfig.isIPhone ? 180 : 240) {
                            withAnimation {
                                selectedUserID = nil 
                                isShowRegisterView = true
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.top)
                }
            }
            .withHeader(title: modelData.appConfig.getPlayerPickerView_PageHeader_Text(), isBackable: false)
            
            // MARK: - Navigation
            .navigationDestination(isPresented: $isShowMenuView) {
                MenuView()
            }
            .navigationDestination(isPresented: $isShowRegisterView) {
                RegisterView()
            }
            
            .onAppear {
                AudioManager.shared.playBackgroundMusic(filename: modelData.appConfig.backgroundMusicName)
            }
        }
    }
    
    func login() {
        guard let userID = selectedUserID else { return }
        session.login(userId: userID)
    }
}

#Preview {
    PlayerPickerView()
        .environment(ModelData.previewModelData)
        .environment(SessionManager.previewSession)
}
