//
//  RemoteFeaturedQuestionLoaderTests.swift
//  InterviewKitTests
//
//  Created by Alexander Nikolaychuk on 09.03.2021.
//

import XCTest

class RemoteFeaturedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

class HTTPClient {
    
    static var shared = HTTPClient()
    
    func get(from url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    
    var requestedURL: URL?
    
    override func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteFeaturedQuestionLoaderTests: XCTestCase {
    
    func test_init_doesntNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeaturedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requetsDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeaturedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
}
