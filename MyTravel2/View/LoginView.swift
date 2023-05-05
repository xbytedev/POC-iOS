//
//  LoginView.swift
//  MyTravel2
//
//  Created by Mrugesh Tank on 05/05/23.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
		ZStack {
			Image(uiImage: UIImage(named: "img_background")!)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.clipped()
				.ignoresSafeArea()
		}
    }
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
			.previewDevice("iPhone 14 Pro")
			.previewDisplayName("iPhone 14 Pro")
		LoginView()
			.previewDevice("iPhone 8 Plus")
			.previewDisplayName("iPhone 8 Plus")
	}
}
