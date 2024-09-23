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

struct PlayerListView: View {
    @Environment(ModelData.self) var modelData
    
    var users: [User]
    @Binding var selectedUserID: UUID?
    
    var sortedUsers: [User] {
        users.filter { $0.type == .human }
             .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        ZStack {
            // Background with blur effect
            Color.black.opacity(0.36)

            ScrollView {
                LazyVStack {
                    ForEach(sortedUsers) { user in
                        if user.type == .human {
                            PlayerRowView(user: user, isSelected: user.id == selectedUserID)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    withAnimation {
                                        if selectedUserID != nil && selectedUserID == user.id {
                                            selectedUserID = nil  // un-select
                                        } else {
                                            selectedUserID = user.id // select
                                        }
                                        
                                        AudioManager.shared.playSoundEffect(filename: modelData.appConfig.profileButtonTapMusic)
                                    }
                                }
                        }
                    }
                }
            }
        }
        .frame(height: modelData.appConfig.isIPhone ? 400 : 600)
    }
}

#Preview {
    PlayerListView(users: ModelData.previewModelData.users,
                   selectedUserID: .constant(ModelData.previewModelData.users[0].id))
        .environment(ModelData.previewModelData)
}
