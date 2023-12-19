#import <Availability.h>
#import "ASWebAuthSession.h"

#import <AuthenticationServices/ASWebAuthenticationSession.h>
#import <Cordova/CDVAvailability.h>

ASWebAuthenticationSession *_authenticationVC;

@implementation ASWebAuthSession;

- (void)pluginInitialize {
}

- (void)start:(CDVInvokedUrlCommand *)command {

    if (@available(iOS 13.0, *)) {
        NSString* redirectScheme = [command.arguments objectAtIndex:0];
        NSURL* requestURL = [NSURL URLWithString:[command.arguments objectAtIndex:1]];
        
        ASWebAuthenticationSession* authenticationVC =
        [[ASWebAuthenticationSession alloc] initWithURL:requestURL
                                   callbackURLScheme:redirectScheme
                                   completionHandler:^(NSURL * _Nullable callbackURL,
                                                       NSError * _Nullable error) {
                                       _authenticationVC = nil;
                                       CDVPluginResult *result;
                                       if (callbackURL) {
                                           result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: callbackURL.absoluteString];

                                       } else {
                                           
                                           result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"error"];
                                       }
                                       [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                                   }];
                                   
        authenticationVC.presentationContextProvider = self;
        _authenticationVC = authenticationVC;
        [authenticationVC start];
    }
}

- (nonnull ASPresentationAnchor)presentationAnchorForWebAuthenticationSession:(nonnull ASWebAuthenticationSession *)session API_AVAILABLE(ios(13.0)){
    return [[[UIApplication sharedApplication] windows] firstObject];
}

@end
