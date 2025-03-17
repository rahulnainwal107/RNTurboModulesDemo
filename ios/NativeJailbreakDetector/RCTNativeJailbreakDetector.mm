//
//  RCTNativeJailbreakDetector.m
//  RNTurboModulesDemo
//
//  Created by Rahul Nainwal on 17/03/25.
//

#import "RCTNativeJailbreakDetector.h"

@implementation RCTNativeJailbreakDetector

RCT_EXPORT_MODULE(JailbreakDetector);

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

// Check if Cydia is installed
- (BOOL)hasCydiaInstalled {
  return [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
}

// Check if the app can edit system files
- (BOOL)isSystemDirectoryWritable {
  NSString *testString = @"Jailbreak Test";
  NSString *filePath = @"/private/jailbreak.txt";
  NSError *error;

  [testString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];

  if (!error) {
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    return YES;
  }
  return NO;
}

// Check for suspicious files that indicate jailbreak
- (BOOL)hasSuspiciousFiles {
  NSArray *paths = @[
    @"/private/var/lib/dpkg/info",
    @"/bin/bash",
    @"/usr/sbin/sshd",
    @"/etc/apt",
    @"/private/var/lib/apt/",
    @"/Applications/Icy.app",
    @"/Applications/FakeCarrier.app",
    @"/Applications/IntelliScreen.app",
    @"/Applications/SBSettings.app",
    @"/Applications/MxTube.app",
    @"/Applications/RockApp.app",
    @"/Applications/Sileo.app",
    @"/Applications/Zebra.app",
    @"/Applications/TrollStore.app"
  ];

  for (NSString *path in paths) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
      return YES;
    }
  }

  return NO;
}

// Check for other suspicious apps
- (BOOL)hasSuspiciousAppsInstalled {
  NSArray *apps = @[
    @"/Applications/FakeCarrier.app",
    @"/Applications/Icy.app",
    @"/Applications/IntelliScreen.app",
    @"/Applications/SBSettings.app",
    @"/Applications/Dopamine.app",
    @"/Applications/Sileo.app",
    @"/Applications/Zebra.app",
    @"/Applications/TrollStore.app"
  ];

  for (NSString *app in apps) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:app]) {
      return YES;
    }
  }
  return NO;
}

// Check if Cydia is installed using alternative names (URIScheme)
- (BOOL)canOpenCydiaAlternativeNames {
  NSArray *urlSchemes = @[
    @"cydia://package/com.example.package",
    @"cydia://",
    @"undecimus://",
    @"sileo://"
  ];

  for (NSString *scheme in urlSchemes) {
    NSURL *url = [NSURL URLWithString:scheme];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
      return YES;
    }
  }

  return NO;
}

// Check if the app is running on a simulator
- (BOOL)isSimulator {
#if TARGET_IPHONE_SIMULATOR
  return YES;
#else
  return NO;
#endif
}

// Check if Substrate (or similar) is installed
- (BOOL)hasSubstrateInstalled {
  NSArray *paths = @[
    @"/usr/libexec/substrate",
    @"/Library/MobileSubstrate/MobileSubstrate.dylib",
    @"/usr/lib/substitute-inserter.dylib",
    @"/usr/lib/libhooker.dylib"
  ];

  for (NSString *path in paths) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
      return YES;
    }
  }

  return NO;
}

// Check if installed via AltStore or Sideloadly
- (BOOL)isInstalledViaAltStoreOrSideloadly {
  return [self hasAltStoreBundleID];
}

// Check for a developer provisioning profile (common for sideloaded apps)
- (BOOL)hasDeveloperProvisioningProfile {
  NSString *profilePath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
  return profilePath != nil;
}

// Check for known AltStore/Sideloadly identifiers
- (BOOL)hasAltStoreBundleID {
  NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
  NSArray *altStoreIDs = @[
    @"com.rileytestut.AltStore",
    @"com.sideloadly"
  ];

  return [altStoreIDs containsObject:bundleID];
}

// Check if installed from App Store
- (BOOL)isInstalledFromAppStore {
  NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
  if (receiptURL) {
    NSString *path = [receiptURL path];
    return [path containsString:@"sandboxReceipt"] || [path containsString:@"receipt"];
  }
  return NO;
}

// Check if Dopamine is installed (URIScheme)
- (BOOL)canOpenDopamineURI {
  NSURL *url = [NSURL URLWithString:@"dopamine://"];
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
    return YES;
  }
  return NO;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeJailbreakDetectorSpecJSI>(params);
}

- (void)isJailbroken:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject {
  printf("isJailbroken lslksklslkkl");
  if (/* DISABLES CODE */ (true)) {
    resolve(@(YES));
  } else {
    reject(@"E_JAILBROKEN_CHECK_FAILED", @"Device is not jailbroken", nil);
  }
}

@end
