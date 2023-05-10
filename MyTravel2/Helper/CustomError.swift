//
//  CustomError.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

enum CustomError: Error {
	case code(Double)
	case message(String)
	case alreadyLoadingOrNoMoredata
	case successButNoData
	case failedButNoMessage

//	static func getError(fromMessage message: String?, orCode code: Double) -> CustomError {
//		if let message {
//			return .message(message)
//		}
//		return  .code(code)
//	}
//
//	static func getError(fromMessage message: String?) -> CustomError {
//		if let message {
//			return .message(message)
//		} else {
//			return .failedButNoMessage
//		}
//	}
}

extension CustomError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .code(let errorCode):
			return R.string.localizable.customErrorCode(errorCode)
		case .message(let errorMessage):
			return errorMessage
		case .alreadyLoadingOrNoMoredata:
			return R.string.localizable.requestInProgressOrNoMoreData()
		case .successButNoData:
			return R.string.localizable.requestSucceedNoData()
		case .failedButNoMessage:
			return R.string.localizable.requestFailedNoMessageFound()
		}
	}
}

extension CustomError: Equatable { }
