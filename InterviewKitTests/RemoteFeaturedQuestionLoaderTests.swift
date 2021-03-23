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
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_init_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: URL(string: "https://a-given-url.com")!)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: URL(string: "https://a-given-url.com")!)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeatureQuestionLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeatureQuestionLoader(url: url, client: client), client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        var requestedURLs = [URL]()
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }
    
}
