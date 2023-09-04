//
//  FriendCell.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit

final class FriendCell: UITableViewCell {
    private var statusTextView: UILabel = {
        let label = UILabel()
        label.text = Constants.FriendStatus.offlineStatusText
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()

    private var photoView = UIImageView(image: UIImage(systemName: "person"))

    private var nameView: UILabel = {
        let label = UILabel()
        label.text = Constants.NoNames.friendNoNameText
        label.textColor = .black
        return label
    }()

    var tap: ((String?, UIImage?) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        setupViews()
        setupConstraints()

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnPhoto)))
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(statusTextView)
        contentView.addSubview(photoView)
        contentView.addSubview(nameView)
    }

    private func setupConstraints() {
        statusTextView.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        nameView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            statusTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            photoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoView.topAnchor.constraint(equalTo: statusTextView.bottomAnchor, constant: 5),
            photoView.widthAnchor.constraint(equalToConstant: 70),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),

            nameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 5),
            nameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    func update(friend: Friend) {
        if friend.online == 0 {
            statusTextView.text = Constants.FriendStatus.offlineStatusText
            statusTextView.textColor = .white
            statusTextView.backgroundColor = .red
        } else {
            statusTextView.text = Constants.FriendStatus.onlineStatusText
            statusTextView.textColor = .black
            statusTextView.backgroundColor = .green
        }

        let firstName = friend.firstName ?? ""
        let lastName = friend.lastName ?? ""

        if firstName.isEmpty && lastName.isEmpty {
            nameView.text = Constants.NoNames.friendNoNameText
        } else if !firstName.isEmpty && !lastName.isEmpty {
            nameView.text = firstName + " " + lastName
        } else if !firstName.isEmpty && lastName.isEmpty {
            nameView.text = firstName
        } else {
            nameView.text = lastName
        }

        DispatchQueue.global().async {
            if let url = URL(string: friend.photo ?? ""), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(data: data)
                }
            }
        }
    }

    @objc private func tapOnPhoto() {
        tap?(nameView.text, photoView.image)
    }
}
