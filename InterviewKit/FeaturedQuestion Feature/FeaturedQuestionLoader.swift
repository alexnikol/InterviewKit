//
//  FeaturedQuestionLoader.swift
//  InterviewKit
//
//  Created by Alexander Nikolaychuk on 09.03.2021.
//

import Foundation

protocol FeaturedQuestionLoader {
    func load(completion: @escaping (Result<FeaturedQuestion, Error>) -> Void)
}
