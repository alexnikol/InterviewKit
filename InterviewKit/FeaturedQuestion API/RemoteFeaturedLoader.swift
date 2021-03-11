//
//  RemoteFeaturedLoader.swift
//  InterviewKit
//
//  Created by Alexander Nikolaychuk on 11.03.2021.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteFeaturedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}
