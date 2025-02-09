//
//  Model.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import Foundation


struct APIResponse: Codable {
    let items: [Item]
}

struct Item: Codable {
    let open_state: OpenState?
    let closed_state: ClosedState?
    let cta_text: String?
}

struct OpenState: Codable {
    let body: Body?
}

struct ClosedState: Codable {
    let body: Body?
}

struct Body: Codable {
    let title: String?
    let subtitle: String?
    let card: Card?
    let footer: String?
    let items: [ItemDetail]?
    let key1: String?
    let key2: String?
}

struct Card: Codable {
    let header: String?
    let description: String?
    let max_range: Int?
    let min_range: Int?
}

struct ItemDetail: Codable, Identifiable, Hashable {
    let emi: String?
    let duration: String?
    let title: String?
    let subtitle: String?
    let tag: String?
    let icon: String?
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        emi = try container.decodeIfPresent(String.self, forKey: .emi)
        duration = try container.decodeIfPresent(String.self, forKey: .duration)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        
        if let subtitleString = try? container.decode(String.self, forKey: .subtitle) {
            subtitle = subtitleString
        } else if let subtitleInt = try? container.decode(Int.self, forKey: .subtitle) {
            subtitle = String(subtitleInt)
        } else {
            subtitle = nil
        }
        
        tag = try container.decodeIfPresent(String.self, forKey: .tag)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
    }
    
    var id: String {
        return title ?? "unknown"
    }
}
