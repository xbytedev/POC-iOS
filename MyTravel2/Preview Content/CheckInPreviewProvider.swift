//
//  CheckInPreviewProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 25/08/23.
//

import Foundation

struct CheckInSuccessProvider: CheckInProvider {
	func getCheckInTravellerList() async -> Result<[MTCheckInTraveller], Error> {
		return .success([.preview])
	}
	func getCheckInPeopleDetails() async -> Result<Void, Error> {
		return .success(())
	}
}

struct CheckInFailureProvider: CheckInProvider {
	func getCheckInTravellerList() async -> Result<[MTCheckInTraveller], Error> {
		.failure(CustomError.message("Mock Failure"))
	}
	func getCheckInPeopleDetails() async -> Result<Void, Error> {
		.failure(CustomError.message("Mock Failure"))
	}
}
