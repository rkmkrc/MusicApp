//
//  Network.swift
//  MusicApp
//
//  Created by Erkam Karaca on 8.05.2023.
//

import Foundation

struct Network {
    static let scheme = "https"
    static let host = "api.deezer.com"
    static let genrePath = "/genre"
    static let artistsPath = "/artists"
    static let artistPath = "/artist"
}

func fetchData<T: Codable>(from url: URL, expecting: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
    let session = URLSession.shared
    
    let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
            completionHandler(.failure(error))
            return
        }
        
        guard let data = data else {
            completionHandler(.failure(NSError(domain: "com.MusicApp.api", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from API"])))
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            completionHandler(.success(decodedData))
        } catch {
            completionHandler(.failure(error))
        }
    }
    task.resume()
}
