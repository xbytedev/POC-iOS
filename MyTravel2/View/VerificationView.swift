//
//  VerificationView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct VerificationView: View {
    var body: some View {
		ZStack {
			backgroundImage
		}
    }

	private var bgImage: some View {
		Image(uiImage: UIImage(named: "img_background")!)
			.resizable()
			.aspectRatio(contentMode: .fill)
			.clipped()
			.frame(minWidth: 0, maxWidth: .infinity)
	}

	private var backgroundImage: some View {
		if #available(iOS 14.0, *) {
			return bgImage.ignoresSafeArea()
		} else {
			return bgImage.edgesIgnoringSafeArea(.all)
		}
	}
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
