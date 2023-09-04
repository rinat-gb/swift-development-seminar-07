//
//  PhotosCollectionViewController.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit

final class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var photosModel: PhotosModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.photosTitle

        collectionView.backgroundColor = Theme.currentTheme.backgroundColor

        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: Constants.CellNames.photosCellName)

        NetworkService().getPhotos { [weak self] photosModel in
            if photosModel.response?.count == 0 {
                // а нету никаких фотографий! меняем заголовое на "Нет фото"
                DispatchQueue.main.async {
                    self?.title = Constants.TitlesNoItems.photosTitle
                }
            } else {
                self?.photosModel = photosModel

                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Theme.currentTheme.backgroundColor
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return photosModel?.response?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellNames.photosCellName, for: indexPath) as? PhotoCell
        else {
            return UICollectionViewCell()
        }
        guard let photo = photosModel?.response?.items?[indexPath.row] else {
            return UICollectionViewCell()
        }
        photoCell.update(photo: photo)
        return photoCell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        // делаем высоту и ширину одинаковыми чтобы получился квадрат
        let size = UIScreen.main.bounds.width / 2 - 10
        return CGSize(width: size, height: size)
    }
}
