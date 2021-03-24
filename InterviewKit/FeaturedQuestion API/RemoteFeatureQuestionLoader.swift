//
//  RemoteFeatureQuestionLoader.swift
//  InterviewKit
//
//  Created by Alexander Nikolaychuk on 11.03.2021.
//

import Foundation

public typealias HTTPClientResultCallback = (Result<(Data, HTTPURLResponse), Error>) -> Void

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping HTTPClientResultCallback)
}

public final class RemoteFeatureQuestionLoader {
    
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<FeaturedQuestion, Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success((let data, _)):
                guard let featuredQuestion = try? JSONDecoder().decode(FeaturedQuestion.self, from: data) else {
                    completion(.failure(.invalidData))
                    return
                }
                completion(.success(featuredQuestion))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
}
