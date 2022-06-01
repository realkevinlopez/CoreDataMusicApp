//
//  DetailViewController.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import UIKit

class DetailViewController : UIViewController {
    
    var viewModel = AlbumListViewModel()
    
    lazy var artistLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Artist: "
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var albumLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Album: "
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var albumImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Genre: "
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Release Date: "
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        
        if (isFavorited == 0){
            button.setImage(UIImage(systemName: "star"), for: [])
        }
        if (isFavorited == 1){
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpUI()
    }
    
    var isFavorited = 0
    
    private func setUpUI() {
        
        if (isFavorited == 0){
            favoriteButton.setImage(UIImage(systemName: "star"), for: [])
        }
        if (isFavorited == 1){
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: [])
        }
        
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.alignment = .center
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(topBuffer)
        vStack.addArrangedSubview(self.albumImage)
        vStack.addArrangedSubview(self.artistLabel)
        vStack.addArrangedSubview(self.albumLabel)
        vStack.addArrangedSubview(self.genreLabel)
        vStack.addArrangedSubview(self.dateLabel)
        vStack.addArrangedSubview(self.favoriteButton)
        vStack.addArrangedSubview(bottomBuffer)
        
        self.albumImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.albumImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.favoriteButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.favoriteButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
        
    }
    
    var index = 0
    
    @objc func buttonAction(_ sender: UIButton){
        
        var hasChanged = 0
        
        if (isFavorited == 0){
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: [])
            isFavorited = 1
            hasChanged += 1
            self.viewModel.changeButtonStatus(index: index)
            self.viewModel.makeFavorited(index: index)
        }
        
        if (isFavorited == 1 && hasChanged == 0){
            favoriteButton.setImage(UIImage(systemName: "star"), for: [])
            isFavorited = 0
            self.viewModel.changeButtonStatus(index: index)
            self.viewModel.removeFavorite(name: artistLabel.text ?? "")
        }
    }
    
}
