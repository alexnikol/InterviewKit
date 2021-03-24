//
//  FeaturedQuestion.swift
//  InterviewKit
//
//  Created by Alexander Nikolaychuk on 09.03.2021.
//

import Foundation

public struct FeaturedQuestion {
    
    public let id: Int
    public let question: String
    public let answer: String
    public let source: String?
    public let difficulty: QuestionDifficulty
    public let attachments: [AnswerAttachment]
    public let categories: [QuestionCategory]
    
    public struct QuestionCategory: Decodable {
        let id: Int
        let title: String
    }

    public enum AnswerAttachment: Decodable {
        
        case text(content: String)
        case image(link: URL)
        
        private enum AnswerAttachmentkeys: String, CodingKey {
            case type, content, link
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: AnswerAttachmentkeys.self)
            let type = try container.decode(String.self, forKey: .type)
            switch type {
            case "text":
                let content = try container.decode(String.self, forKey: .content)
                self = .text(content: content)
            case "image":
                let link = try container.decode(URL.self, forKey: .link)
                self = .image(link: link)
            default:
                throw NSError(domain: "Decode Error", code: 0)
            }
        }
    }

    public enum QuestionDifficulty: String, Decodable {
        case easy, medium, advanced
    }
    
    public init(id: Int,
                  question: String,
                  answer: String,
                  source: String?,
                  difficulty: FeaturedQuestion.QuestionDifficulty,
                  attachments: [FeaturedQuestion.AnswerAttachment],
                  categories: [FeaturedQuestion.QuestionCategory]) {
        self.id = id
        self.question = question
        self.answer = answer
        self.source = source
        self.difficulty = difficulty
        self.attachments = attachments
        self.categories = categories
    }
    
}

extension FeaturedQuestion: Equatable {
    public static func == (lhs: FeaturedQuestion, rhs: FeaturedQuestion) -> Bool {
        return lhs.id == rhs.id
    }
}

extension FeaturedQuestion: Decodable {
    
    private enum Codingkeys: String, CodingKey {
        case id, question, answer, source, difficulty, attachments, categories
    }
    
}
