{
  flake.nixosModules.chromium-policies.programs.chromium = {
    enable = true;

    extraOpts = {
      AdsSettingForIntrusiveAdsSites = 2;

      AdvancedProtectionAllowed = false;

      AIModeSettings = 1;

      AccessControlAllowMethodsInCORSPreflightSpecConformant = true;

      AlwaysOpenPdfExternally = false;

      AmbientAuthenticationInPrivateModesEnabled = 0;

      AudioSandboxEnabled = true;

      AutofillAddressEnabled = false;

      AutofillCreditCardEnabled = false;

      AutofillPredictionSettings = 2;

      BookmarkBarEnabled = true;

      BrowserLabsEnabled = false;

      BrowserSignin = 0;

      BuiltInAIAPIsEnabled = false;

      BuiltInDnsClientEnabled = false;

      ChromeForTestingAllowed = false;

      CloudExtensionRequestEnabled = false;

      CloudProfileReportingEnabled = false;

      CloudReportingEnabled = false;

      ClickToCallEnabled = false;

      CloudManagementEnrollmentMandatory = false;

      CloudPolicyOverridesPlatformPolicy = false;

      CloudUserPolicyMerge = false;

      CloudUserPolicyOverridesCloudMachinePolicy = false;

      CommandLineFlagSecurityWarningsEnabled = true;

      CompressionDictionaryTransportEnabled = true;

      DefaultBrowserSettingEnabled = false;

      DesktopSharingHubEnabled = false;

      DeveloperToolsAvailability = 1;

      DeviceGuestModeEnabled = false;

      DisableSafeBrowsingProceedAnyway = false;

      EnableOnlineRevocationChecks = true;

      EncryptedClientHelloEnabled = true;

      FeedbackSurveysEnabled = false;

      FirstPartySetsEnabled = false;

      ForceGoogleSafeSearch = false;

      ForceYouTubeRestrict = 0;

      GenAiDefaultSettings = 2;

      GoogleSearchSidePanelEnabled = false;

      HttpsOnlyMode = "force_balanced_enabled";

      HttpsUpgradesEnabled = true;

      ImportAutofillFormData = false;

      ImportBookmarks = false;

      ImportHistory = false;

      ImportHomepage = false;

      ImportSavedPasswords = false;

      ImportSearchEngine = false;

      IncognitoModeAvailability = 0;

      IntranetRedirectBehavior = 2;

      IPv6ReachabilityOverrideEnabled = false;

      NetworkServiceSandboxEnabled = true;

      OutOfProcessSystemDnsResolutionEnabled = true;

      PasswordManagerEnabled = false;

      PaymentMethodQueryEnabled = false;

      PolicyAtomicGroupsEnabled = true;

      PostQuantumKeyAgreementEnabled = true;

      PrefetchWithServiceWorkerEnabled = false;

      PrivacySandboxAdMeasurementEnabled = true;

      PrivacySandboxAdTopicsEnabled = true;

      PrivacySandboxFingerprintingProtectionEnabled = true;

      PrivacySandboxIpProtectionEnabled = true;

      PrivacySandboxPromptEnabled = true;

      PrivacySandboxSiteEnabledAdsEnabled = true;

      ProfilePickerOnStartupAvailability = 0;

      ProfileSeparationSettings = 1;

      PromotionsEnabled = false;

      QuicAllowed = true;

      SafeBrowsingProtectionLevel = 0;

      SafeBrowsingSurveysEnabled = false;

      SharedArrayBufferUnrestrictedAccessAllowed = false;

      SharedClipboardEnabled = false;

      SpellcheckEnabled = true;

      SpellcheckLanguage = [
        "bg"
        "en-US"
      ];

      SyncDisabled = true;

      UserSecurityAuthenticatedReporting = false;

      UserSecuritySignalsReporting = false;
    };
  };
}
