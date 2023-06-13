//
//  WebRequester.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation
import Alamofire

struct WebRequesterSessionProvider {
	static let authStorage = KeychainStorage()
	static let session: Session = {
		let sessionConfiguration = URLSessionConfiguration.af.default
		sessionConfiguration.timeoutIntervalForRequest = 30
		let networkLogger = MTNetworkLogger()
		let session: Session
		let requestInterceptor = MTRequestInterceptor(tokenProvider: authStorage)
		session = .init(configuration: sessionConfiguration, interceptor: requestInterceptor, eventMonitors: [networkLogger])
		return session
	}()
}

class WebRequester<MTDecodable: Decodable> {
	private let session: Session
	private var decoder = MTJSONDecoder()

	init(withSession session: Session) {
		self.session = session
	}

	func request<MTEncodable: Encodable>(toURL url: String, method: HTTPMethod = .post, withParameters
										 param: MTEncodable?) async -> Result<MTDecodable, Error> {
		let dataTask = session.request(url, method: method, parameters: param)
			.validate(statusCode: 200..<300)
			.validate(contentType: ["application/json"])
			.serializingDecodable(MTDecodable.self, decoder: decoder)
		do {
			let value = try await dataTask.value
			return .success(value)
		} catch {
			return .failure(error)
		}
	}
}

func getOriginalErrorIfAny(_ error: Error) -> Error {
	if let afError = error as? AFError,
	   let originalError = afError.underlyingError {
		return originalError
	}
	return error
}
