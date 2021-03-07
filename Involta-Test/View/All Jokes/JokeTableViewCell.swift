//
//  JokeCell.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import UIKit

class JokeTableViewCell: UITableViewCell {
    
    //MARK: - Public Properties
    static let reuseIdentifier = "JokeCell"
    
    @IBOutlet weak var idLabel: UILabel?
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var setupLabel: UILabel?
    @IBOutlet weak var punchlineLabel: UILabel?
    
    //MARK: - Configure UI
    func configureUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0.137254902, green: 0.4078431373, blue: 0.7215686275, alpha: 1)
    }
    
    func configureLabels(id: Int, type: String, setup: String, punchline: String) {
        idLabel?.text = "ID:" + " " + "\(id)"
        typeLabel?.text = "TYPE:" + " " + type
        setupLabel?.text = "SETUP:" + " " + setup
        punchlineLabel?.text = "PUNCHLINE:" + " " + punchline
    }
}
