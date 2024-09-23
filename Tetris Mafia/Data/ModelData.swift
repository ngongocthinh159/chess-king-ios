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

var modelDataFileName = "modelData.json"

@Observable
class ModelData: Codable {
    var appConfig: AppConfig
    var users: [User ]
    
    init() {
        self.appConfig = AppConfig(theme: .halloween, boardTheme: .halloween)
        self.users = [User(name: "Thinh Ngo", avatar: .dog), User(name: "Thy Nguyen", avatar: .cat )]
    }
    
    init(appConfig: AppConfig, users: [User ]) {
        self.appConfig = appConfig
        self.users = users 
    }
    
    func getUser(byId id: UUID) -> User? {
        return users.first(where: { $0.id == id })
    }
    
    func getUserByName(name: String) -> User? {
        return users.first(where: { $0.name.lowercased() == name.lowercased() })
    }
    
    func save() {
        FileStorageManager.shared.save(self, to: modelDataFileName)
    }
    
    func getUserIndexByName(name: String) -> Int? {
        return users.firstIndex { $0.name == name }
    }
    
    func saveUser(user: User) {
        let index = getUserIndexByName(name: user.name)
        if index != nil {
            users[index!] = user
            self.save()
        }
    }
    
    func loadOrInitData() -> ModelData {
        return FileStorageManager.shared.load(from: modelDataFileName, type: ModelData.self , default: ModelData.getInitialModelData())
    }
    
    // For preview
    static var previewModelData: ModelData = ModelData(
        appConfig: AppConfig(theme: .halloween, boardTheme: .halloween),
        users: [
            User(name: "Thinh Ngo", avatar: .dog, badges: [.firstPlay, .beatHardAI]),
            User(name: "Thy Nguyen", avatar: .cat),
            User(name: "Bomman", avatar: .mouse, badges: [.firstPlay, .beatHardAI]),
            User(name: "I Love TomHuynh", avatar: .dog),
            User(name: "Hacker lord", avatar: .cat),
            User(name: "Michael Jordan", avatar: .mouse),
            User(name: "A", avatar: .mouse),
            
            User(name: "Michael the dumb AI", avatar: .dog, type: .ai),
            User(name: "Alex the clever AI", avatar: .cat, type: .ai),
            User(name: "TomHuynh super AI", avatar: .mouse, type: .ai),
        ]
    )
    
    static func getInitialModelData() -> ModelData {
        return ModelData(
            appConfig: AppConfig(theme: .halloween, 
                                 boardTheme: .wood,
                                 aiDifficulty: .easy,
                                 isSoundOn: true,
                                 language: .EN),
            users: User.generateMockUsers(count: 12)
//            users: [
//                User(name: "Thinh Ngo", avatar: .dog, badges: [.firstPlay, .beatHardAI]),
//                User(name: "Thy Nguyen", avatar: .cat),
//                User(name: "Bomman", avatar: .mouse, badges: [.firstPlay, .beatHardAI]),
//                User(name: "I Love TomHuynh", avatar: .dog),
//                User(name: "Hacker lord", avatar: .cat),
//                User(name: "Michael Jordan", avatar: .mouse),
//                User(name: "A", avatar: .mouse),
//                
//                User(name: "Michael the dumb AI", avatar: .dog, type: .ai),
//                User(name: "Alex the clever AI", avatar: .cat, type: .ai),
//                User(name: "TomHuynh super AI", avatar: .mouse, type: .ai),
//            ]
        )
    }
}
