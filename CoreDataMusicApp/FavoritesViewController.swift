//
//  FavoritesViewController.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var viewModel: AlbumListViewModelType
    var albumNames: [String] = []
    var artistNames: [String] = []
    
    lazy var albumTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseId)
        return table
    }()
    
    init(viewModel: AlbumListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        self.viewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.albumTableView.reloadData()
            }
        }
        self.viewModel.getAlbums()
        albumNames = self.viewModel.allAlbumNames()
        artistNames = self.viewModel.allArtistNames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
        
    }
    
    func viewLoadSetup(){
        self.setUpUI()
        self.viewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.albumTableView.reloadData()
            }
        }
        self.viewModel.getAlbums()
        albumNames = self.viewModel.allAlbumNames()
        artistNames = self.viewModel.allArtistNames()
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.albumTableView)
        self.albumTableView.bindToSuperView()
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artistNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseId, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .white
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.favoriteLabel.textColor = .black
        cell.titleLabel.text = "Album: " + self.albumNames[indexPath.row]
        cell.titleLabel.textColor = .black
        cell.artistLabel.text = "Artist: " + self.artistNames[indexPath.row]
        cell.artistLabel.textColor = .black
        
        if (self.viewModel.buttonStatus(index: indexPath.row) == 0){
            cell.favoriteButton.setImage(UIImage(systemName: "star"), for: [])
        }
        
        if (self.viewModel.buttonStatus(index: indexPath.row) == 1) {
            cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: [])
        }
        
        cell.buttonPressedAction = { [] in
            var isFavorite = 0
            
            if (self.viewModel.buttonStatus(index: indexPath.row) == 0){
                cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: [])
                self.viewModel.changeButtonStatus(index: indexPath.row)
                isFavorite += 1
                self.viewModel.makeFavorited(index: indexPath.row)
            }
            if (self.viewModel.buttonStatus(index: indexPath.row) == 1 && isFavorite == 0) {
                cell.favoriteButton.setImage(UIImage(systemName: "star"), for: [])
                self.viewModel.changeButtonStatus(index: indexPath.row)
                self.viewModel.removeFavorite(name: self.viewModel.artistName(index: indexPath.row) ?? "")
            }
        }
        
        self.viewModel.imageData(index: indexPath.row) { data in
            if let data = data {
                DispatchQueue.main.async {
                    cell.albumImageView.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.viewModel.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        self.viewModel.getAlbums()
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier:  "DetailViewController") as? DetailViewController else { return }
        vc.artistLabel.text = self.viewModel.artistName(index: indexPath.row) ?? ""
        vc.albumLabel.text = self.viewModel.albumTitle(index: indexPath.row) ?? ""
        vc.genreLabel.text = self.viewModel.albumGenre(index: indexPath.row) ?? ""
        vc.dateLabel.text = self.viewModel.dateReleased(index: indexPath.row)
        vc.isFavorited = self.viewModel.buttonStatus(index: indexPath.row)
        vc.viewModel = self.viewModel as! AlbumListViewModel
        vc.index = indexPath.row
        
        self.viewModel.imageData(index: indexPath.row) { data in
            if let data = data {
                DispatchQueue.main.async {
                    vc.albumImage.image = UIImage(data: data)
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
}
