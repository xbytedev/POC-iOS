//
//  MTBackButton.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/05/23.
//

import SwiftUI

struct MTBackButton: View {
	@Environment(\.mtDismissable) var dismiss

	var body: some View {
		Button(action: dismiss) {
			Image(systemName: "chevron.backward")
				.resizable()
				.roundButton()
		}
	}
}

struct MTBackButton_Previews: PreviewProvider {
    static var previews: some View {
        MTBackButton()
    }
}
