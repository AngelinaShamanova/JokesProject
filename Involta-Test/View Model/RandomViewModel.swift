//
//  RandomViewModel.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import Foundation

class RandomJokeViewModel {
    
    //MARK: - Private Properties
    private let url = "https://official-joke-api.appspot.com/random_joke"
    private let storageManager = StorageManager()
    
    //MARK: - Public Properties
    var jokeModel: JokeModel?
    var remoteJoke: [JokeModel]?
    
    //MARK: - Upload joke from net
    func loadJoke(completion: @escaping (String?) -> Void) {
        request { [weak self] (response, message) in
            guard let self = self else { return }
            switch response {
            case let .success(joke):
                self.jokeModel = joke
                self.storageManager.isOnline = true
                completion(message)
            case .failure(_):
                self.storageManager.isOnline = false
                completion(nil)
            case .none:
                self.storageManager.isOnline = false
                completion(nil)
            }
        }
    }
    
    //MARK: - Get request
    private func request(completion: @escaping (Swift.Result<JokeModel, Error>?, String?) -> Void)  {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let data = data,
               let joke = try? JSONDecoder().decode(JokeModel.self, from: data) {
                completion(.success(joke), nil)
            } else if let error = error  {
                completion(.failure(error), nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                completion(nil, httpResponse.statusCode.description)
            }
        }.resume()
    }
}
