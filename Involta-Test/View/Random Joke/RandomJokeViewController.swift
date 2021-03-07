//
//  RandomJokeViewController.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import UIKit

class RandomJokeViewController: UIViewController {
    
    //MARK: - Public Properties
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var punchlineLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    //MARK: - Private Properties
    private let viewModel = RandomJokeViewModel()
    private let allJokesViewModel = AllJokesViewModel()
    private let storageManager = StorageManager()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        getRandomJoke()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.activityIndicator?.isHidden = false
            self.activityIndicator?.startAnimating()
        }
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 12
        activityIndicator?.isHidden = true
    }
    
    //MARK: - Get random joke from net
    private func getRandomJoke() {
        viewModel.loadJoke { [weak self] message in
            
            guard let self = self else { return }
            guard let jokeData = self.viewModel.jokeModel else { return }
            
            DispatchQueue.main.async {
                self.idLabel.text = "ID:" + " " + "\(jokeData.id)"
                self.typeLabel.text = "TYPE:" + " " + jokeData.type
                self.jokeLabel.text = "SETUP:" + " " + jokeData.setup
                self.punchlineLabel.text = "PUNCHLINE:" + " " + jokeData.punchline
                
                self.activityIndicator?.stopAnimating()
                self.activityIndicator?.removeFromSuperview()
            }
            
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                self.activityIndicator?.removeFromSuperview()
            }
        }
        
        if self.storageManager.isOnline == false {
            self.viewModel.remoteJoke = self.storageManager.getRemoteJokesFromDB()
            let randomJoke = self.viewModel.remoteJoke?.randomElement()
            self.viewModel.jokeModel = randomJoke
            
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            
            guard let joke = self.viewModel.jokeModel else { return }
            
            self.idLabel.text = "ID:" + " " + "\(joke.id))"
            self.typeLabel.text = "TYPE:" + " " + (joke.type)
            self.jokeLabel.text = "SETUP:" + " " + (joke.setup)
            self.punchlineLabel.text = "PUNCHLINE:" + " " + (joke.punchline)
            
            self.storageManager.isOnline = nil
        }
    }
}
