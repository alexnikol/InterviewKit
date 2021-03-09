//
//  RemoteFeaturedQuestionLoaderTests.swift
//  InterviewKitTests
//
//  Created by Alexander Nikolaychuk on 09.03.2021.
//

import XCTest

class RemoteFeaturedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeaturedQuestionLoaderTests: XCTestCase {
    
    func test_init_doesntNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeaturedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
}
