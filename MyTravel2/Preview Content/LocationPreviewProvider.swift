//
//  LocationProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import Foundation

struct LocationSuccessProvider: LocationProvider {
	func getPlaceList() async -> Result<[MTPlace], Error> {
		return .success([MTPlace.preview])
	}
}

struct LocationFailureProvider: LocationProvider {
	func getPlaceList() async -> Result<[MTPlace], Error> {
		return .failure(CustomError.message("Mock Failure"))
	}
}
