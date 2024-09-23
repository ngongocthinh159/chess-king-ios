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

class FileStorageManager {
    static let shared = FileStorageManager()
    
    private var documentsDirectory: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            fatalError("Couldn't find documents directory.")
        }
    }
    
    func save<T: Codable>(_ object: T, to filename: String) {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL, options: [.atomicWrite])
            print("Saved successfully to \(fileURL)")
        } catch {
            print("Failed to save to \(fileURL): \(error)")
        }
    }
    
    func load<T: Codable>(from filename: String, type: T.Type) -> T? {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            print("Load file from \(fileURL)")
            let data = try Data(contentsOf: fileURL)
            let decodedObject = try JSONDecoder().decode(type, from: data)
            return decodedObject
        } catch {
            print("Failed to load from \(fileURL): \(error)")
            return nil
        }
    }
    
    func removeFile(with filename: String) {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("File \(filename) successfully removed from \(fileURL).")
        } catch {
            print("Failed to remove file \(filename): \(error)")
        }
    }
}

extension FileStorageManager {
    func load<T: Codable>(from filename: String, type: T.Type, default: T) -> T {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            print("Load file from \(fileURL)")
            let data = try Data(contentsOf: fileURL)
            let decodedObject = try JSONDecoder().decode(type, from: data)
            return decodedObject
        } catch {
            print("Failed to load from \(fileURL): \(error). Returning default.")
            return `default`
        }
    }
}
