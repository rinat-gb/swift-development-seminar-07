//
//  PhotosModel.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

struct PhotosModel: Codable {
    var response: PhotosResponse?
}

struct PhotosResponse: Codable {
    var count: Int
    var items: [Photo]?
}

struct Photo: Codable {
    var id: Int
    var name: String?
    var sizes: [Sizes]?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "text"
        case sizes
    }
}

struct Sizes: Codable {
    var type: String
    var url: String
    var width: Int
    var height: Int
}
