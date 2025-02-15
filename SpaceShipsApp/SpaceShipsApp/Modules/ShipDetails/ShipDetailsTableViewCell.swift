//
//  ShipDetailsTableViewCell.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 15/02/2025.
//

import UIKit

class ShipDetailsTableViewCell: UITableViewCell {
    static let identifier = "ShipDetailCell"
    
    private var cellNameLabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var cellValueLabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        addSubview(cellNameLabel)
        addSubview(cellValueLabel)
        
        NSLayoutConstraint.activate([
            cellNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            cellNameLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor),
            cellNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            cellNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            
            cellValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            cellValueLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            cellValueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            cellValueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    func setLabelsText(with cellName: String, and cellValue: String) {
        cellNameLabel.text = cellName
        cellValueLabel.text = cellValue
    }
}
