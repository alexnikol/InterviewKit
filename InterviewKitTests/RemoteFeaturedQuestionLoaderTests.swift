//
//  RemoteFeaturedQuestionLoaderTests.swift
//  InterviewKitTests
//
//  Created by Alexander Nikolaychuk on 09.03.2021.
//

import XCTest
import InterviewKit

class RemoteFeaturedQuestionLoaderTests: XCTestCase {
    
    func test_init_doesntNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requetsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: URL(string: "https://a-given-url.com")!)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeaturedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeaturedLoader(url: url, client: client), client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
    
}
