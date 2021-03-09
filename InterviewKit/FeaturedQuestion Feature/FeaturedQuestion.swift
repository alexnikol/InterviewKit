//
//  FeaturedQuestion.swift
//  InterviewKit
//
//  Created by Alexander Nikolaychuk on 09.03.2021.
//

import Foundation

struct FeaturedQuestion {
    let id: Int
    let question: String
    let answer: String
    let source: String?
    let difficulty: QuestionDifficulty
    let attachments: [AnswerAttachment]
    let categories: [QuestionCategory]
}

struct QuestionCategory {
    let id: Int
    let title: String
}

enum AnswerAttachment {
    case text(content: String)
    case image(link: URL)
}

enum QuestionDifficulty {
    case easy, medium, advanced
}
