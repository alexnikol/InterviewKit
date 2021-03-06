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
        
        expect(sut, toCompleteWithResult: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
                
        let sampleCodes = [199, 201, 300, 400, 500].enumerated()
        sampleCodes.forEach { index, code in
            expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid jons".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversValidDataOn200HTTPResponseWithValidJSON() {
        let (sut, client) = makeSUT()
        
        let item = FeaturedQuestion(
            id: 1,
            question: "Any Question",
            answer: "Any Answer",
            source: nil,
            difficulty: .easy,
            attachments: [],
            categories: []
        )
        
        let itemJSON: [String: Any] = [
            "id": item.id,
            "question": item.question,
            "answer": item.answer,
            "difficulty": item.difficulty.rawValue,
            "categories": [],
            "attachments": []
        ]
        
        expect(sut, toCompleteWithResult: .success(item)) {
            let json = try! JSONSerialization.data(withJSONObject: itemJSON)
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeatureQuestionLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeatureQuestionLoader(url: url, client: client), client)
    }
    
    private func expect(
        _ sut: RemoteFeatureQuestionLoader,
        toCompleteWithResult result: RemoteFeatureQuestionLoader.Result,
        when action: ( () -> Void ),
        file: StaticString = #file,
        line: UInt = #line) {
        
        var capturedResult = [RemoteFeatureQuestionLoader.Result]()
        sut.load { capturedResult.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResult, [result], file: file, line: line)
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
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success((data, response)))
        }
        
    }
    
}
