//
//  NetworkManager.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import Foundation

protocol ShipsFetchable {
    func fetchShipsData(completion: @escaping (Result<Data,Error>) -> ())
}

final class NetworkManager {
    private let base = "https://api.spacexdata.com/v3"
    private let subdirectory = "/ships"
    private var url: URL {
        URL(string: base + subdirectory)!
    }
}

extension NetworkManager: ShipsFetchable {
    func fetchShipsData(completion: @escaping (Result<Data, Error>) -> ()) {
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
