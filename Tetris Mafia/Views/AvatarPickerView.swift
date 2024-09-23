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

struct AvatarPickerView: View {
    @Environment(ModelData.self) var modelData
    
    @Binding  var selectedAvatar: Avatar
    var onAvatarPicked: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeneralTitle(title: modelData.appConfig.getAvatarPickerView_ChooseAvatar_Text())
            
            HStack(spacing: modelData.appConfig.isIPhone ? 16 : 32) {
                ForEach(Avatar.allCases, id: \.self) { avatar in
                    Button {
                        selectedAvatar = avatar
                        onAvatarPicked?()
                        
                        AudioManager.shared.playSoundEffect(filename: modelData.appConfig.settingTapMusic)
                    } label: {
                        AvatarSelection(image: avatar.toImageString(), isSelected: avatar == selectedAvatar ? true : false )
                    }
                }
            }
        }
    }
}

#Preview {
    AvatarPickerView(selectedAvatar: .constant(.dog), onAvatarPicked: {})
        .environment(ModelData.previewModelData)
}
