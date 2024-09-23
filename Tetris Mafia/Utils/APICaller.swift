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

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case noData
    case decodingError
}

class APICaller {
    static let shared = APICaller()

    // Function for GET request
    func fetchData<T: Decodable>(to urlString: String, queryParams: [String: String]?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Construct the URL with query parameters if any
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let queryParams = queryParams {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(.noData))
                return
            }
            
            do {
                // Print the data as a string
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received data: \(jsonString)")
                }
                
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }

    // Function for POST request with optional headers and JSON encoding
    func postData<T: Encodable, U: Decodable>(to urlString: String, data: T, headers: [String: String]? = nil, completion: @escaping (Result<U, NetworkError>) -> Void) {
        print("POST url: \(urlString), data: \(data)")
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.decodingError))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                print("Error: \(String(describing: error?.localizedDescription))")
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data else {
                print("No data received.")
                completion(.failure(.noData))
                return
            }
            
            // Print the data as a string for debugging purposes
            if let dataString = String(data: data, encoding: .utf8) {
                print("Received data: \(dataString)")
            } else {
                print("Data is not in valid UTF-8 format.")
            }

            do {
                
                let decodedData = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
