//
//  VerificationView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct VerificationView: View {
	@State private var isLoading = false
	@State private var otpValue = ""
    var body: some View {
		ScrollView {
			VStack(spacing: 36) {
				VStack(spacing: 8) {
					Image(R.image.img_verification)
						.resizable()
						.scaledToFit()
						.padding(.horizontal)
					Text(R.string.localizable.verificationCode)
						.font(AppFont.getFont(forStyle: .title1, forWeight: .bold))
						.foregroundColor(AppColor.theme)
					Text(R.string.localizable.weHaveSentVerificationCode)
						.font(AppFont.getFont(forStyle: .headline, forWeight: .medium))
						.foregroundColor(AppColor.theme)
				}
				OTPView(otpDigitCount: 4, otpString: $otpValue)
				Text(R.string.localizable.resendInTime("00:30"))
					.font(AppFont.getFont(forStyle: .headline, forWeight: .medium))
					.foregroundColor(AppColor.theme)
				MTButton(isLoading: $isLoading, title: R.string.localizable.verify(), loadingTitle: R.string.localizable.verifying()) {
				}
			}
			.padding()
		}
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
