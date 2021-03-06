// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//


#if DEPLOYMENT_RUNTIME_OBJC || os(Linux)
    import Foundation
    import XCTest
#else
    import SwiftFoundation
    import SwiftXCTest
#endif


class TestNSURLResponse : XCTestCase {
    static var allTests: [(String, (TestNSURLResponse) -> () throws -> Void)] {
        return [
            ("test_URL", test_URL),
            ("test_MIMEType_1", test_MIMEType_1),
            ("test_MIMEType_2", test_MIMEType_2),
            ("test_ExpectedContentLength", test_ExpectedContentLength),
            ("test_TextEncodingName", test_TextEncodingName),
            ("test_suggestedFilename", test_suggestedFilename),
            ("test_suggestedFilename_2", test_suggestedFilename_2),
            ("test_suggestedFilename_3", test_suggestedFilename_3),
        ]
    }
    
    func test_URL() {
        let url = NSURL(string: "a/test/path")!
        let res = NSURLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.url, url, "should be the expected url")
    }
    
    func test_MIMEType_1() {
        let mimetype = "text/plain"
        let res = NSURLResponse(url: NSURL(string: "test")!, mimeType: mimetype, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.mimeType, mimetype, "should be the passed in mimetype")
    }
    
    func test_MIMEType_2() {
        let mimetype = "APPlication/wordperFECT"
        let res = NSURLResponse(url: NSURL(string: "test")!, mimeType: mimetype, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.mimeType, mimetype, "should be the other mimetype")
    }

    func test_ExpectedContentLength() {
        let zeroContentLength = 0
        let positiveContentLength = 100
        let url = NSURL(string: "test")!
        let res1 = NSURLResponse(url: url, mimeType: "text/plain", expectedContentLength: zeroContentLength, textEncodingName: nil)
        XCTAssertEqual(res1.expectedContentLength, Int64(zeroContentLength), "should be Int65 of the zero length")
        let res2 = NSURLResponse(url: url, mimeType: "text/plain", expectedContentLength: positiveContentLength, textEncodingName: nil)
        XCTAssertEqual(res2.expectedContentLength, Int64(positiveContentLength), "should be Int64 of the positive content length")
    }
    
    func test_TextEncodingName() {
        let encoding = "utf8"
        let url = NSURL(string: "test")!
        let res1 = NSURLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: encoding)
        XCTAssertEqual(res1.textEncodingName, encoding, "should be the utf8 encoding")
        let res2 = NSURLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertNil(res2.textEncodingName)
    }
    
    func test_suggestedFilename() {
        let url = NSURL(string: "a/test/name.extension")!
        let res = NSURLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.suggestedFilename, "name.extension")
    }
    
    func test_suggestedFilename_2() {
        let url = NSURL(string: "a/test/name.extension?foo=bar")!
        let res = NSURLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.suggestedFilename, "name.extension")
    }
    
    func test_suggestedFilename_3() {
        let url = NSURL(string: "a://bar")!
        let res = NSURLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.suggestedFilename, "Unknown")
    }
}


class TestNSHTTPURLResponse : XCTestCase {
    static var allTests: [(String, (TestNSHTTPURLResponse) -> () throws -> Void)] {
        return [
                   ("test_URL_and_status_1", test_URL_and_status_1),
                   ("test_URL_and_status_2", test_URL_and_status_2),

                   ("test_headerFields_1", test_headerFields_1),
                   ("test_headerFields_2", test_headerFields_2),
                   ("test_headerFields_3", test_headerFields_3),
                   
                   ("test_contentLength_available_1", test_contentLength_available_1),
                   ("test_contentLength_available_2", test_contentLength_available_2),
                   ("test_contentLength_available_3", test_contentLength_available_3),
                   ("test_contentLength_available_4", test_contentLength_available_4),
                   ("test_contentLength_notAvailable", test_contentLength_notAvailable),
                   ("test_contentLength_withTransferEncoding", test_contentLength_withTransferEncoding),
                   ("test_contentLength_withContentEncoding", test_contentLength_withContentEncoding),
                   ("test_contentLength_withContentEncodingAndTransferEncoding", test_contentLength_withContentEncodingAndTransferEncoding),
                   ("test_contentLength_withContentEncodingAndTransferEncoding_2", test_contentLength_withContentEncodingAndTransferEncoding_2),
                   
                   ("test_suggestedFilename_notAvailable_1", test_suggestedFilename_notAvailable_1),
                   ("test_suggestedFilename_notAvailable_2", test_suggestedFilename_notAvailable_2),
                   ("test_suggestedFilename_1", test_suggestedFilename_1),
                   ("test_suggestedFilename_2", test_suggestedFilename_2),
                   ("test_suggestedFilename_3", test_suggestedFilename_3),
                   ("test_suggestedFilename_4", test_suggestedFilename_4),
                   ("test_suggestedFilename_removeSlashes_1", test_suggestedFilename_removeSlashes_1),
                   ("test_suggestedFilename_removeSlashes_2", test_suggestedFilename_removeSlashes_2),
                   
                   ("test_MIMETypeAndCharacterEncoding_1", test_MIMETypeAndCharacterEncoding_1),
                   ("test_MIMETypeAndCharacterEncoding_2", test_MIMETypeAndCharacterEncoding_2),
                   ("test_MIMETypeAndCharacterEncoding_3", test_MIMETypeAndCharacterEncoding_3),
        ]
    }
    
    let url = NSURL(string: "https://www.swift.org")!
    
    func test_URL_and_status_1() {
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["Content-Length": "5299"])
        XCTAssertEqual(sut?.url, url)
        XCTAssertEqual(sut?.statusCode, 200)
    }
    func test_URL_and_status_2() {
        let url = NSURL(string: "http://www.apple.com")!
        let sut = NSHTTPURLResponse(url: url, statusCode: 302, httpVersion: "HTTP/1.1", headerFields: ["Content-Length": "5299"])
        XCTAssertEqual(sut?.url, url)
        XCTAssertEqual(sut?.statusCode, 302)
    }

    func test_headerFields_1() {
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        XCTAssertEqual(sut?.allHeaderFields.count, 0)
    }
    func test_headerFields_2() {
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [:])
        XCTAssertEqual(sut?.allHeaderFields.count, 0)
    }
    func test_headerFields_3() {
        let f = ["A": "1", "B": "2"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.allHeaderFields.count, 2)
        XCTAssertEqual(sut?.allHeaderFields["A"], "1")
        XCTAssertEqual(sut?.allHeaderFields["B"], "2")
    }
    
    // Note that the message content length is different from the message
    // transfer length.
    // The transfer length can only be derived when the Transfer-Encoding is identity (default).
    // For compressed content (Content-Encoding other than identity), there is not way to derive the
    // content length from the transfer length.
    //
    // C.f. <https://tools.ietf.org/html/rfc2616#section-4.4>
    
    func test_contentLength_available_1() {
        let f = ["Content-Length": "997"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, 997)
    }
    func test_contentLength_available_2() {
        let f = ["Content-Length": "997", "Transfer-Encoding": "identity"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, 997)
    }
    func test_contentLength_available_3() {
        let f = ["Content-Length": "997", "Content-Encoding": "identity"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, 997)
    }
    func test_contentLength_available_4() {
        let f = ["Content-Length": "997", "Content-Encoding": "identity", "Transfer-Encoding": "identity"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, 997)
    }
    
    func test_contentLength_notAvailable() {
        let f = ["Server": "Apache"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, -1)
    }
    func test_contentLength_withTransferEncoding() {
        let f = ["Content-Length": "997", "Transfer-Encoding": "chunked"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, 997)
    }
    func test_contentLength_withContentEncoding() {
        let f = ["Content-Length": "997", "Content-Encoding": "deflate"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, 997)
    }
    func test_contentLength_withContentEncodingAndTransferEncoding() {
        let f = ["Content-Length": "997", "Content-Encoding": "deflate", "Transfer-Encoding": "identity"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, 997)
    }
    func test_contentLength_withContentEncodingAndTransferEncoding_2() {
        let f = ["Content-Length": "997", "Content-Encoding": "identity", "Transfer-Encoding": "chunked"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.expectedContentLength, 997)
    }
    
    // The `suggestedFilename` can be derived from the "Content-Disposition"
    // header as defined in RFC 1806 and more recently RFC 2183
    // https://tools.ietf.org/html/rfc1806
    // https://tools.ietf.org/html/rfc2183
    //
    // Typical use looks like this:
    //     Content-Disposition: attachment; filename="fname.ext"
    //
    // As noted in https://tools.ietf.org/html/rfc2616#section-19.5.1 the
    // receiving user agent SHOULD NOT respect any directory path information
    // present in the filename-parm parameter.
    //
    
    func test_suggestedFilename_notAvailable_1() {
        let f: [String: String] = [:]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.suggestedFilename, "Unknown")
    }
    func test_suggestedFilename_notAvailable_2() {
        let f = ["Content-Disposition": "inline"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.suggestedFilename, "Unknown")
    }
    
    func test_suggestedFilename_1() {
        let f = ["Content-Disposition": "attachment; filename=\"fname.ext\""]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.suggestedFilename, "fname.ext")
    }
    func test_suggestedFilename_2() {
        let f = ["Content-Disposition": "attachment; filename=genome.jpeg; modification-date=\"Wed, 12 Feb 1997 16:29:51 -0500\";"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.suggestedFilename, "genome.jpeg")
    }
    func test_suggestedFilename_3() {
        let f = ["Content-Disposition": "attachment; filename=\";.ext\""]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.suggestedFilename, ";.ext")
    }
    func test_suggestedFilename_4() {
        let f = ["Content-Disposition": "attachment; aa=bb\\; filename=\"wrong.ext\"; filename=\"fname.ext\"; cc=dd"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.suggestedFilename, "fname.ext")
    }
    func test_suggestedFilename_removeSlashes_1() {
        let f = ["Content-Disposition": "attachment; filename=\"/a/b/name\""]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.suggestedFilename, "_a_b_name")
    }
    func test_suggestedFilename_removeSlashes_2() {
        let f = ["Content-Disposition": "attachment; filename=\"a/../b/name\""]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.suggestedFilename, "a_.._b_name")
    }
    
    // The MIME type / character encoding
    
    func test_MIMETypeAndCharacterEncoding_1() {
        let f = ["Server": "Apache"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertNil(sut?.mimeType)
        XCTAssertNil(sut?.textEncodingName)
    }
    func test_MIMETypeAndCharacterEncoding_2() {
        let f = ["Content-Type": "text/html"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.mimeType, "text/html")
        XCTAssertNil(sut?.textEncodingName)
    }
    func test_MIMETypeAndCharacterEncoding_3() {
        let f = ["Content-Type": "text/HTML; charset=ISO-8859-4"]
        let sut = NSHTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: f)
        XCTAssertEqual(sut?.mimeType, "text/html")
        XCTAssertEqual(sut?.textEncodingName, "iso-8859-4")
    }
}
