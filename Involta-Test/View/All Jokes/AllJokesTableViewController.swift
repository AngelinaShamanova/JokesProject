//
//  AllJokesTableViewController.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import UIKit

class AllJokesTableViewController: UITableViewController {
    
    //MARK: - Private Properties
    private let viewModel = AllJokesViewModel()
    private let storageManager = StorageManager()
    private var remoteJokes = [JokeModel]()
    
    //MARK: - Public Properties
    var getJokesForTheFirstTime = true
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        getAllJokes()
    }
    
    //MARK: - Get jokes from net
    func getAllJokes() {
        viewModel.getTenJokes { [weak self] message in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if message == nil {
                    self.viewModel.allJokes = self.viewModel.jokes
                    self.storageManager.removeFromDB()
                    self.storageManager.saveJokesToDB(allJokes: self.viewModel.allJokes)
                    self.tableView.reloadData()
                } else {
                    if self.viewModel.allJokes.count == 0 {
                        self.viewModel.allJokes = self.storageManager.getRemoteJokesFromDB()
                        self.tableView.reloadData()
                    }
                    if self.viewModel.allJokes.count > 0 {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allJokes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JokeTableViewCell.reuseIdentifier, for: indexPath) as? JokeTableViewCell else { return UITableViewCell() }
        
        cell.configureUI()
        if self.viewModel.allJokes.count > indexPath.row {
            cell.configureLabels(id: viewModel.allJokes[indexPath.row].id,
                                 type: viewModel.allJokes[indexPath.row].type,
                                 setup: viewModel.allJokes[indexPath.row].setup,
                                 punchline: viewModel.allJokes[indexPath.row].punchline)
        }
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

//MARK: - Extension for pagination
extension AllJokesTableViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == viewModel.allJokes.count {
            if !(self.getJokesForTheFirstTime) {
                
                self.viewModel.getTenJokes { [self] message in
                    DispatchQueue.main.async {
                        if message == nil {
                            for new in self.viewModel.jokes {
                                if !viewModel.allJokes.contains(new) {
                                    self.viewModel.allJokes.append(new)
                                }
                            }
                            self.tableView.reloadData()
                            self.storageManager.saveJokesToDB(allJokes: self.viewModel.allJokes)
                        }
                    }
                }
            }
            self.getJokesForTheFirstTime = false
        }
    }
}
