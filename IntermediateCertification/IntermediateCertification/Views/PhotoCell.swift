//
//  PhotoCell.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    private var imageView = UIImageView(image: UIImage(systemName: "person"))

    private var nameView: UILabel = {
        let label = UILabel()
        label.text = Constants.NoNames.photoNoNameText
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(nameView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),

            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            imageView.bottomAnchor.constraint(equalTo: nameView.topAnchor, constant: -2),

            nameView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(photo: Photo) {
        nameView.text = photo.name ?? Constants.NoNames.photoNoNameText

        DispatchQueue.global().async {
            if let url = URL(string: photo.sizes?.first?.url ?? ""), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(systemName: "person")
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
