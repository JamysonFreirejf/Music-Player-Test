//
//  ViewController.swift
//  Music Player Test
//
//  Created by Jamyson Freire on 15/08/20.
//  Copyright © 2020 Doji. All rights reserved.
//

import UIKit

final class AlbumsViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UINib(nibName: AlbumCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        }
    }
    
    private var viewModel = AlbumsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeCollumnsClick(_ sender: Any) {
        viewModel.toggleCollumns { [weak self] in
            self?.viewModel.skipAnimation = false
            self?.collectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.viewModel.skipAnimation = true
            }
        }
    }
}

extension AlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        cell.setUpView(album: viewModel.albums[indexPath.item], animationType: viewModel.animationType, skipAnimation: viewModel.skipAnimation)
        return cell
    }
}

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / viewModel.collumns.rawValue,
                      height: viewModel.collumns == .one ? 268 : 223)
    }
}

extension AlbumsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "DetailsView") else { return }
        navigationController?.pushViewController(viewController, animated: false)
    }
}
