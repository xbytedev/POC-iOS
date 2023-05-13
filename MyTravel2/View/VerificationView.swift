//
//  VerificationView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct VerificationView: View {
	@State private var isLoading = false
    var body: some View {
		VStack(spacing: 36) {
			VStack(spacing: 8) {
				Image(R.image.img_verification)
					.resizable()
					.scaledToFit()
					.padding(.horizontal)
				Text("Verification Code")
					.font(AppFont.getFont(forStyle: .title1, forWeight: .bold))
					.foregroundColor(AppColor.theme)
				Text("We have sent the verification code to your email.")
					.font(AppFont.getFont(forStyle: .headline, forWeight: .medium))
					.foregroundColor(AppColor.theme)
			}
			Text("Resend in 00 : 30")
				.font(AppFont.getFont(forStyle: .headline, forWeight: .medium))
				.foregroundColor(AppColor.theme)
			MTButton(isLoading: $isLoading, title: "Verify", loadingTitle: "Verifying") {
			}
		}
		.padding()
    }

}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
