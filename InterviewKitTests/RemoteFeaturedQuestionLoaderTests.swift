//
//  RemoteFeaturedQuestionLoaderTests.swift
//  InterviewKitTests
//
//  Created by Alexander Nikolaychuk on 09.03.2021.
//

import XCTest

class RemoteFeaturedLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteFeaturedQuestionLoaderTests: XCTestCase {
    
    func test_init_doesntNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeaturedLoader(url: URL(string: "https://a-url.com")!, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requetsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeaturedLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
}
