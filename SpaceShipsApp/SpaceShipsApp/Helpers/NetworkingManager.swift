//
//  NetworkManager.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import Foundation

protocol Fetchable {
    func fetchData(with urlString: String, completion: @escaping (Result<Data,Error>) -> ())
}

final class NetworkingManager: Fetchable {
    func fetchData(with urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
