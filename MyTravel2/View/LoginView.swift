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
	private(set) var viewModel: AuthViewModel
	@State private var shouldVerify = false
	@State private var shouldGoToWelcome = false
	@State var configuration = UIConfiguration()

	var body: some View {
		ZStack {
			NavigationLink(isActive: $shouldGoToWelcome, destination: {
				WelcomeView(rootIsActive: $shouldGoToWelcome)
			}, label: {
				EmptyView()
			})
			.opacity(0)
			loginView
				.onAppear {
					if MTUserDefaults.currentUser != nil {
						shouldGoToWelcome = true
					}
				}
		}
	}

	var loginView: some View {
		ZStack {
			backgroundImage
			VStack {
				VStack(spacing: 0) {
					MTTextField(label: R.string.localizable.username(), valueStr: $usernameStr)
						.textContentType(.username)
					MTTextField(label: R.string.localizable.password(), valueStr: $passwordStr, isPassword: true)
						.textContentType(.password)
				}
				VStack(spacing: 16) {
					HStack {
						Spacer()
						forgotPasswordView
					}
					if #available(iOS 15.0, *) {
						Text(getAttrStr())
					} else {
						Text("Don't have an account? Register")
							.onTapGesture {
								// TODO: handle tap on register
							}
					}
				}
			}
			.padding(.init(top: 48, leading: 0, bottom: 24, trailing: 0))
			.modifier(FormModifier())
			.myOverlay(alignment: .bottom) {
				NavigationLink(isActive: $shouldVerify) {
					VerificationView(viewModel: viewModel, rootIsActive: $shouldVerify)
				} label: {
					MTButton(
						isLoading: $configuration.isLoading,
						title: R.string.localizable.login(),
						loadingTitle: R.string.localizable.logginIn()) {
							handleLoginAction()
						}
						.frame(maxWidth: .infinity)
						.padding(.horizontal, 64)
						.offset(x: 0, y: 20)
						.showAlert(isPresented: $configuration.alertPresent) {
							Text(configuration.errorMeessage)
						}
				}
			}
			.myOverlay(alignment: .top) {
				Image(R.image.ic_avatar)
					.frame(height: 48)
					.aspectRatio(contentMode: .fit)
					.padding(24)
					.myBackground {
						Circle()
							.foregroundColor(AppColor.theme.opacity(0.9))
					}
					.offset(x: 0, y: -36)
			}
		}
		.myOverlay(alignment: .top) {
			Image(R.image.img_myTravelLogo)
				.resizable()
				.scaledToFit()
				.frame(height: 128)
				.padding(.vertical)
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

	private var forgotPasswordView: some View {
		NavigationLink {
			Text("Forgot password")
		} label: {
			Text(R.string.localizable.forgotPassword)
				.font(AppFont.getFont(forStyle: .subheadline, forWeight: .medium))
				.foregroundColor(AppColor.Text.secondary)
		}
	}

	@available(iOS 15, *)
	private func getAttrStr() -> AttributedString {
		var str1 = AttributedString(R.string.localizable.doNotHaveAnAccount())
		str1.font = AppFont.getFont(forStyle: .subheadline, forWeight: .medium)
		str1.foregroundColor = AppColor.Text.secondary

		var str2 = AttributedString(R.string.localizable.register())
		str2.font = AppFont.getFont(forStyle: .subheadline, forWeight: .semibold)
		str2.foregroundColor = AppColor.theme
		str2.link = URL(string: "https://google.com")

		return str1 + str2
	}

	func handleLoginAction() {
		do {
			_ = try validate()
			configuration.isLoading = true
			configuration.alertPresent = false
			Task {
				do {
					_ = try await viewModel.doLogin(email: usernameStr, password: passwordStr)
					self.configuration.isLoading = false
					self.shouldVerify = true
				} catch {
					self.configuration.errorMeessage = error.localizedDescription
					self.configuration.alertPresent = true
					self.configuration.isLoading = false
				}
			}
		} catch {
			configuration.alertPresent = true
			configuration.errorMeessage = error.localizedDescription
		}

		func validate() throws -> Bool {
			if usernameStr.isEmpty {
				throw CustomError.message(R.string.localizable.pleaseEnterYourEmail())
			} else if !Validator.shared.isValidEmail(usernameStr) {
				throw CustomError.message(R.string.localizable.pleaseEnterYourValidEmail())
			} else if passwordStr.isEmpty {
				throw CustomError.message(R.string.localizable.pleaseEnterYourPassword())
			}
			return true
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = AuthViewModel(provider: AuthAPIProvider())
		LoginView(viewModel: viewModel)
			.previewDevice("iPhone 14 Pro")
			.previewDisplayName("iPhone 14 Pro")
		LoginView(viewModel: viewModel)
			.previewDevice("iPhone 8 Plus")
			.previewDisplayName("iPhone 8 Plus")
	}
}

extension View {
	func showAlert(
		title: String = R.string.localizable.error(), isPresented: Binding<Bool>,
		defaultButtonTitle: String = R.string.localizable.ok(), action: @escaping () -> Void = { },
		@ViewBuilder messageView: () -> Text) -> some View {
			if #available(iOS 15.0, *) {
				return self.alert(
					title, isPresented: isPresented,
					actions: { Button(action: action, label: { Text(defaultButtonTitle)}) },
					message: messageView)
			} else {
				return self.alert(isPresented: isPresented) {
					Alert(
						title: Text(title), message: messageView(),
						dismissButton: .default(Text(defaultButtonTitle), action: action))
				}
			}
		}
}
