//
//  NetworkManager.swift
//  CoreInterface
//
//  Created by chuchu on 2/23/24.
//

import Foundation

import Alamofire

public struct NetworkManager {
    public static let shared = NetworkManager()
    @frozen
    public enum API {
        case contactUs(SlackMessageModel)
        
        var urlString: String {
            switch self {
            case .contactUs(_): UserDefaultsManager.shared.contactUrl
            }
        }
        var url: URL { URL(string: urlString)! }
        
        var method: HTTPMethod {
            switch self {
            case .contactUs(_): .post
            }
        }
        
        var parameters: [String: Any] {
            switch self {
            case .contactUs(let model): model.json
            }
        }
        
        var encoder: ParameterEncoding {
            switch self {
            case .contactUs(_): JSONEncoding()
            }
        }
        
        var headers: HTTPHeaders { ["Content-Type": "application/json"] }
    }
    
    public func request(api: API, completion: @escaping (AFDataResponse<Data?>) -> Void) {
        AF.request(api.url,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoder,
                   headers: api.headers).response(completionHandler: completion)
    }
}

public class SlackMessageModel: Codable {
    var blocks: [SlackBlock]
    
    public init(blocks: [SlackBlock] = []) {
        self.blocks = blocks
    }
}

// MARK: - SlackMessageModel function
extension SlackMessageModel {
    @discardableResult
    public func addBlock(blockType: SlackBlock.BlockType) -> Self {
        let block = SlackBlock.makeBlock(block: blockType)
        self.blocks.append(block)
        return self
    }
}

public struct SlackBlock: Codable {
    let type: String
    let text: SlackText?
    var imageURL: String?
    var altText: String?

    enum CodingKeys: String, CodingKey {
        case type, text
        case imageURL = "image_url"
        case altText = "alt_text"
    }
    
    public init(type: String, text: SlackText?, imageURL: String? = nil, altText: String? = nil) {
        self.type = type
        self.text = text
        self.imageURL = imageURL
        self.altText = altText
    }
}


//MARK: SlackBlock Enum
extension SlackBlock {
    public enum BlockType {
        case header(String)
        case title(String)
        case subtitle(String)
        case contents(String)
        case osType
        case image
        case divider
        
        var type: String {
            switch self {
            case .header(_): "header"
            case .title(_), .subtitle(_), .contents(_), .osType: "section"
            case .image: "image"
            case .divider: "divider"
            }
        }
        
        var text: SlackText {
            switch self {
            case .header(let text): SlackText(type: "plain_text", text: text)
            case .title(let text): SlackText(type: "mrkdwn", text: "*제목*\n" + text)
            case .subtitle(let text): SlackText(type: "mrkdwn", text: "*연락처*\n" + text)
            case .contents(let text): SlackText(type: "mrkdwn", text: "*내용*\n" + text)
            case .osType: SlackText(type: "mrkdwn", text: "OS: 🍎iOS🍎")
            case .image: SlackText(type: type, text: "")
            case .divider: SlackText(type: type, text: "")
            }
        }
    }
}


//MARK: SlackBlock function
extension SlackBlock {
    public static func makeBlock(block: BlockType) -> SlackBlock {
        switch block {
        case .header(_),
                .title(_),
                .subtitle(_),
                .contents(_),
                .osType : SlackBlock(type: block.type, text: block.text)
        case .image: SlackBlock(type: block.type, text: nil, imageURL: nil, altText: nil)
        case .divider: SlackBlock(type: block.type, text: nil)
        }
    }
}

public struct SlackText: Codable {
    let type, text: String
    
    public init(type: String, text: String) {
        self.type = type
        self.text = text
    }
}
