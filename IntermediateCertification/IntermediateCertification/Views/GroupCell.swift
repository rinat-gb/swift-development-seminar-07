//
//  GroupCell.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit

final class GroupCell: UITableViewCell {
    private var photoView = UIImageView(image: UIImage(systemName: "trash"))

    private var nameView: UILabel = {
        let label = UILabel()
        label.text = Constants.NoNames.groupNoNameText
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private var descriptionView: UILabel = {
        let label = UILabel()
        label.text = Constants.NoNames.groupNoDescriptionText
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(photoView)
        contentView.addSubview(nameView)
        contentView.addSubview(descriptionView)
    }

    private func setupConstraints() {
        photoView.translatesAutoresizingMaskIntoConstraints = false
        nameView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photoView.widthAnchor.constraint(equalToConstant: 70),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),

            nameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 5),

            descriptionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 5),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    func update(group: Group) {
        nameView.text = group.name ?? Constants.NoNames.groupNoNameText
        descriptionView.text = group.description ?? Constants.NoNames.groupNoDescriptionText

        DispatchQueue.global().async {
            if let url = URL(string: group.photo ?? ""), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(systemName: "trash")
                }
            }
        }
    }
}
