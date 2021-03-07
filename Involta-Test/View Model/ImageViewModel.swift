//
//  ImageViewModel.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import UIKit

class ImageViewModel: NSObject {
    
    //MARK: - Private Properties
    private static var sharedManager: ImageViewModel = {
        let viewModel = ImageViewModel()
        return viewModel
    }()
    private var image = UIImage()
    
    //MARK: - Public Properties
    let imagesUrl = ["https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/5.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/9.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/10.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/11.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/12.jpeg",
                     "https://rickandmortyapi.com/api/character/avatar/20.jpeg"]
    var randomNumber = Int()
    
    //MARK: - Get random image
    func makeRandomNumber() {
        randomNumber = Int.random(in: 0...(imagesUrl.count - 1))
    }
    
    //MARK: - Get image from net
    func getImageFrom(url: String, completion: @escaping (UIImage?, String?) -> ()) {
        request(url: url) { [weak self] response, message in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                print(data)
                if let image = UIImage(data: data) {
                    self.image = image
                    completion(image, nil)
                } else {
                    completion(nil, "ERROR")
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
            case .none:
                completion(nil, message)
            }
        }
    }
    
    //MARK: - Get request
    private func request(url: String, completion: @escaping (Swift.Result<Data, Error>?, String?) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion(.success(data), nil)
            } else if let error = error  {
                completion(.failure(error), nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                completion(nil, httpResponse.statusCode.description)
            }
        }.resume()
    }
    
    class func shared() -> ImageViewModel {
        return sharedManager
    }
}
