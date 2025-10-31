//
//  GoogleMobileAdsConsentManager.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/30/25.
//

import Foundation
import GoogleMobileAds
import UserMessagingPlatform

/// The Google Mobile Ads SDK provides the User Messaging Platform (Google's
/// IAB Certified consent management platform) as one solution to capture
/// consent for users in GDPR impacted countries. This is an example and
/// you can choose another consent management platform to capture consent.

@MainActor
class GoogleMobileAdsConsentManager: NSObject {
    static let shared = GoogleMobileAdsConsentManager()
    
    var canRequestAds: Bool {
        return ConsentInformation.shared.canRequestAds
    }
    
    var isPrivacyOptionsRequired: Bool {
        return ConsentInformation.shared.privacyOptionsRequirementStatus == .required
    }
    
    /// Helper method to call the UMP SDK methods to request consent information and load/present a
    /// consent form if necessary.
    func gatherConsent(
        from viewController: UIViewController? = nil,
        consentGatheringComplete: @escaping (Error?) -> Void
    ) {
        let parameters = RequestParameters()
        
        // For testing purposes, you can use UMPDebugGeography to simulate a location.
        let debugSettings = DebugSettings()
        // debugSettings.geography = DebugGeography.EEA
        parameters.debugSettings = debugSettings
        
        // Requesting an update to consent information should be called on every app launch.
        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) {
            requestConsentError in
            guard requestConsentError == nil else {
                return consentGatheringComplete(requestConsentError)
            }
            
            Task { @MainActor in
                do {
                    try await ConsentForm.loadAndPresentIfRequired(from: viewController)
                    // Consent has been gathered.
                    consentGatheringComplete(nil)
                } catch {
                    consentGatheringComplete(error)
                }
            }
        }
    }
    
    /// Helper method to call the UMP SDK method to present the privacy options form.
    @MainActor func presentPrivacyOptionsForm(from viewController: UIViewController? = nil)
    async throws
    {
        try await ConsentForm.presentPrivacyOptionsForm(from: viewController)
    }
}
