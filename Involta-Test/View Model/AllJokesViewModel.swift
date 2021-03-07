//
//  AllJokesViewModel.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import UIKit

class AllJokesViewModel {
    
    //MARK: - Public Properties
    let url = "https://official-joke-api.appspot.com/random_ten"
    var jokes = [JokeModel]()
    var allJokes = [JokeModel]()
    var isOnline: Bool? = nil
    
    //MARK: - Get tean jokes
    func getTenJokes(completion: @escaping (String?) -> Void) {
        request { [weak self] (response, message) in
            guard let self = self else { return }
            switch response {
            case let .success(jokes):
                self.jokes = jokes
                self.isOnline = true
                completion(nil)
            case .failure(let error):
                self.isOnline = false
                completion(error.localizedDescription)
            case .none:
                self.isOnline = false
                completion(message)
            }
        }
    }
    
    //MARK: - Get request
    private func request(completion: @escaping ((Swift.Result<[JokeModel], Error>?, String?) -> Void)) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let data = data,
               let jokes = try? JSONDecoder().decode([JokeModel].self, from: data) {
                completion(.success(jokes), nil)
            } else if let error = error  {
                completion(.failure(error), nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                completion(nil, httpResponse.statusCode.description)
            }
        }.resume()
    }
}

