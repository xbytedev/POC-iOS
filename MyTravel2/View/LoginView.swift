//
//  LoginView.swift
//  MyTravel2
//
//  Created by Mrugesh Tank on 05/05/23.
//

import SwiftUI

struct LoginView: View {
	@State private var usernameStr = ""
	@State private var passwordStr = ""
	@State private var isRequesting = false

    var body: some View {
		ZStack {
			backgroundImage
			VStack {
				VStack(spacing: 0) {
					MTTextField(label: "Username", valueStr: $usernameStr)
						.textContentType(.username)
					MTTextField(label: "Password", valueStr: $passwordStr, isPassword: true)
						.textContentType(.password)
				}
				VStack(spacing: 16) {
					HStack {
						Spacer()
						forgotPasswordView
					}
					Text(getAttrStr())
				}
			}
			.padding(.init(top: 48, leading: 0, bottom: 24, trailing: 0))
			.modifier(FormModifier())
			.overlay(alignment: .bottom) {
				MTButton(isLoading: $isRequesting, title: "Login", loadingTitle: "Loggin in") {
					withAnimation {
						isRequesting.toggle()
					}
				}
				.frame(maxWidth: .infinity)
				.padding(.horizontal, 64)
				.offset(x: 0, y: 20)
			}
			.overlay(alignment: .top) {
				Image(R.image.ic_avatar)
					.frame(height: 48)
					.aspectRatio(contentMode: .fit)
					.padding(24)
					.background {
						Circle()
							.foregroundColor(AppColor.theme.opacity(0.9))
					}
					.offset(x: 0, y: -36)
			}
		}
		.overlay(alignment: .top) {
			Image(R.image.img_myTravelLogo)
				.resizable()
				.scaledToFit()
				.frame(height: 128)
				.padding(.vertical)
		}
    }

	private var backgroundImage: some View {
		Image(uiImage: UIImage(named: "img_background")!)
			.resizable()
			.aspectRatio(contentMode: .fill)
			.clipped()
			.frame(minWidth: 0, maxWidth: .infinity)
			.ignoresSafeArea()
	}

	private var forgotPasswordView: some View {
		NavigationLink {
			Text("Forgot password")
		} label: {
			Text("Forgot Password?")
				.font(AppFont.getFont(forStyle: .subheadline, forWeight: .medium))
				.foregroundColor(AppColor.Text.secondary)
		}
	}

	private func getAttrStr() -> AttributedString {
		var str1 = AttributedString("Don't have an account? ")
		str1.font = AppFont.getFont(forStyle: .subheadline, forWeight: .medium)
		str1.foregroundColor = AppColor.Text.secondary

		var str2 = AttributedString("Register")
		str2.font = AppFont.getFont(forStyle: .subheadline, forWeight: .semibold)
		str2.foregroundColor = AppColor.theme
		str2.link = URL(string: "https://google.com")

		return str1 + str2
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
