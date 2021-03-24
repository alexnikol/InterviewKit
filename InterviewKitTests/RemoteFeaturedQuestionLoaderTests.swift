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
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedError = [RemoteFeatureQuestionLoader.Error]()
        sut.load { error in
            capturedError.append(error)
        }
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
                
        let sampleCodes = [199, 201, 300, 400, 500].enumerated()
        sampleCodes.forEach { index, code in
            var capturedError = [RemoteFeatureQuestionLoader.Error]()
            sut.load { capturedError.append($0) }
            client.complete(withStatusCode: code, at: index)
            XCTAssertEqual(capturedError, [.invalidData])
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeatureQuestionLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeatureQuestionLoader(url: url, client: client), client)
    }
    
    private class HTTPClientSpy: HTTPClient {
                
        private var messages = [(url: URL, completion: HTTPClientResultCallback)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping HTTPClientResultCallback) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(response))
        }
        
    }
    
}
