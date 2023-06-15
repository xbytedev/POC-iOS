//
//  AddTravellerPreviewProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/06/23.
//

import Foundation

struct AddTravellerSuccessProvider: AddTravellerProvider {
	func addTraveler(to group: MTGroup, with code: Int) async -> Result<Bool, Error> {
		return .success(true)
	}
}

struct AddTravellerFailureProvider: AddTravellerProvider {
	func addTraveler(to group: MTGroup, with code: Int) async -> Result<Bool, Error> {
		return .failure(CustomError.message("Mock Failure"))
	}
}
