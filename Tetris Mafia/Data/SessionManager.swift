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

import Foundation

@Observable
class SessionManager {
    private var modelData: ModelData?
    private var userID: UUID?
    
    init() {
        
    }

    init(modelData: ModelData) {
        self.modelData = modelData
    }
    
    func setup(with modelData: ModelData) {
        self.modelData = modelData
    }
    
    var user: User  {
        return self.modelData?.getUser(byId: self.userID!) ?? User(name: "Anonymouse", avatar: .dog)
    }
    
    func login(userId: UUID) {
        self.userID = userId
        self.modelData?.getUser(byId: userId)?.lastLogin = Date.now 
        self.modelData?.save()
    }
    
    func logOut() {
        
    }
    
    func register(userName: String, avatar: Avatar)  {
        let newUser = User(name: userName, avatar: avatar)
        self.userID = newUser.id
        self.modelData?.users.append(newUser)
        self.modelData?.save()
    }
    
    func save() {
        self.modelData?.save()
    }
    
    // For preview
    init(modelData: ModelData, userID: UUID, forMock: String) {
        self.modelData = modelData
        self.userID = userID
    }
    static var previewSession: SessionManager = SessionManager(
        modelData: ModelData.previewModelData,
        userID: ModelData.previewModelData.users[0].id,
        forMock: ""
    )
}
