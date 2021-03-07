//
//  MainViewController.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Public Properties
    @IBOutlet weak var goJokeButton: UIButton!
    @IBOutlet weak var allJokesButton: UIButton!
    @IBOutlet weak var randomImage: UIImageView!
    
    //MARK: - Private Properties
    private let viewModel = ImageViewModel()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        getImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeAnimation(view: goJokeButton)
        makeAnimation(view: allJokesButton)
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        view.applyGradient(colours: [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)])
        goJokeButton.alpha = 0
        allJokesButton.alpha = 0
        
        goJokeButton.setTitle("Шутка", for: .normal)
        allJokesButton.setTitle("Больше шуток", for: .normal)
    }
    
    //MARK: - Get image from net
    private func getImage() {
        viewModel.makeRandomNumber()
        uploadImageFrom(array: viewModel.imagesUrl, for: viewModel.randomNumber)
    }
    
    private func uploadImageFrom(array: [String], for index: Int) {
        viewModel.getImageFrom(url: array[index]) { [weak self] image, message in
            DispatchQueue.main.async {
                if message == nil {
                    if let picture = image {
                        self?.randomImage.image = picture
                    }
                }
            }
        }
    }
}

//MARK: - Extension for animation
extension MainViewController {
    func makeAnimation(view: UIView) {
        UIView.animate(withDuration: 2.0,
                       delay: 0.0, animations: {
                        view.frame = view.frame.offsetBy(dx: 0, dy: -400)
                        view.layer.opacity = 1.0
                       })
    }
}
