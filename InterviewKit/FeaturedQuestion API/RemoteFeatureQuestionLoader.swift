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
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                completion(.connectivity)
            }
        })
    }
    
}
