//
//  FriendsModel.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

struct FriendsModel: Codable {
    var response: FriendsResponse?
}

struct FriendsResponse: Codable {
    var count: Int
    var items: [Friend]?
}

struct Friend: Codable {
    var id: Int
    var online: Int8
    var firstName: String?
    var lastName: String?
    var photo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case online
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_50"
    }
}
