//
//  TableViewCell.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import UIKit

class TableCell: UITableViewCell {
    
    static let reuseId = "\(TableCell.self)"
    
    var buttonPressedAction : (() -> ())?
    
    lazy var albumImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        
        if (buttonStatus == 0){
            button.setImage(UIImage(systemName: "star"), for: [])
        }
        if (buttonStatus == 1){
            button.setImage(UIImage(systemName: "star.fill"), for: [])
        }
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var favoriteLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Favorite"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var artistLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        self.contentView.addSubview(self.albumImageView)
        self.contentView.addSubview(self.favoriteButton)
        
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .center
        
        let favHStack = UIStackView(frame: .zero)
        favHStack.translatesAutoresizingMaskIntoConstraints = false
        favHStack.axis = .horizontal
        favHStack.spacing = 8
        favHStack.alignment = .center
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        
        favHStack.addArrangedSubview(self.favoriteButton)
        favHStack.addArrangedSubview(self.favoriteLabel)
        
        vStack.addArrangedSubview(topBuffer)
        vStack.addArrangedSubview(self.albumImageView)
        vStack.addArrangedSubview(self.artistLabel)
        vStack.addArrangedSubview(self.titleLabel)
        vStack.addArrangedSubview(favHStack)
        vStack.addArrangedSubview(bottomBuffer)
        
        self.contentView.addSubview(vStack)
        
        vStack.bindToSuperView(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        self.albumImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.albumImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.favoriteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.favoriteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
    }
    
    var buttonStatus = 0
    
    override func prepareForReuse() {
        self.albumImageView.image = nil
        if (buttonStatus == 0){
            favoriteButton.setImage(UIImage(systemName: "star"), for: [])
        }
        if (buttonStatus == 1){
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: [])
        }
        self.titleLabel.text = nil
        self.artistLabel.text = nil
    }
    
    @objc func buttonAction(_ sender: UIButton){
        buttonPressedAction?()
    }
    
}
