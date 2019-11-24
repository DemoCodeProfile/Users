//
//  User.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email: String?
    let avatarUrl: String?
    var createdAt: Date? = nil

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        if let createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            self.createdAt = formatter.date(from: createdAt)
        }
    }
    
    init(
        id: Int?,
        firstName: String?,
        lastName: String?,
        email: String?,
        avatarUrl: String?,
        createdAt: Date? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.avatarUrl = avatarUrl
        self.createdAt = createdAt
    }
}
