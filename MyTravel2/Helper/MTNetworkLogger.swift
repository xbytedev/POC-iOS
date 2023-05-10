//
//  MTNetworkLogger.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation
import Alamofire
import os.log

struct MTNetworkLogger: EventMonitor {
	let queue = DispatchQueue(label: bundleIdentifier + ".networklogger")
	private let logger = Logger(subsystem: bundleIdentifier, category: "NetworkLogger")

	// Event called when any type of Request is resumed.
	func requestDidResume(_ request: Request) {
		if let request = request.request {
			if let url = request.url {
				logger.debug("Request URL: \(url.absoluteString, privacy: .private)")
			}
			if let method = request.httpMethod {
				logger.debug("Request Method: \(method, privacy: .private)")
			}
			if let header = request.allHTTPHeaderFields {
				logger.debug("Request Header: \(header, privacy: .private)")
			}
			if let body = request.httpBody {
				logger.debug("Request Body: \(String(data: body, encoding: String.Encoding.utf8) ?? "")")
			}
		}
	}

	// Event called whenever a DataRequest has parsed a response.
	func request<Decodable>(_ request: DataRequest, didParseResponse response: DataResponse<Decodable, AFError>) {
		if let url = request.request?.url {
			logger.debug("Received response of request URL: \(url.absoluteString, privacy: .private)")
		}
		if let data = response.data {
			logger.debug("Response Data: \(String(data: data, encoding: .utf8) ?? "NO DATA", privacy: .private)")
		}
	}
}
