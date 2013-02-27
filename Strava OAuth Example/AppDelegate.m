//
//  AppDelegate.m
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/7/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import "AppDelegate.h"

#import "AFJSONRequestOperation.h"
#import "OAuthWindowController.h"
#import "StravaClient.h"
#import "StravaOAuthApplication.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSDictionary* athlete;
@property (weak) IBOutlet NSTextField *nameLabel;
@property (weak) IBOutlet NSImageView *profileImageView;
@property (nonatomic, strong) OAuthWindowController* oauthWindowController;
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@end

@implementation AppDelegate

#pragma mark - Accessors

- (void)setAthlete:(NSDictionary *)newAthlete
{
    if (_athlete != newAthlete) {
        _athlete = newAthlete;
        if (self.athlete) {
            self.nameLabel.hidden = NO;
            self.profileImageView.hidden = NO;
            
            self.nameLabel.stringValue = [NSString stringWithFormat:@"Hello, %@ %@", [self.athlete valueForKey:@"firstname"], [self.athlete valueForKey:@"lastname"]];            
            self.profileImageView.image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[self.athlete valueForKey:@"profile"]]];
        } else {
            self.nameLabel.hidden = YES;
            self.profileImageView.hidden = YES;
        }
    }
}

#pragma mark - Application Lifecycle

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

#pragma mark - Actions

- (IBAction)connectWithStrava:(id)sender
{
    if ([StravaOAuthApplication currentApplication].clientId) {
        [sender setHidden:YES];
        self.progressBar.hidden = NO;
        [self.progressBar startAnimation:self];
        self.oauthWindowController = [[OAuthWindowController alloc] initWithDelegate:self];
        [self.oauthWindowController showWindow:sender];
    } else {
        NSAlert* alert = [NSAlert alertWithMessageText:@"Strava OAuth Application Is Not Configured" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Configure your Client ID and Secret in StravaOAuthApplication.m"];
        [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}

#pragma mark - OAuthWindowControllerDelegate

- (void)windowController:(OAuthWindowController *)controller didReceiveAccessToken:(NSString *)accessToken
{
    [StravaClient setAccessToken:accessToken];
    
    NSURLRequest* request = [[StravaClient sharedClient] requestWithMethod:@"GET" path:@"/api/v3/athlete" parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id athlete) {
        self.athlete = athlete;
        [self.progressBar stopAnimation:self];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSAlert* alert = [NSAlert alertWithError:error];
        [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.progressBar stopAnimation:self];
    }];
    [operation start];
}

- (void)windowController:(OAuthWindowController *)controller didFail:(NSError *)error
{
    [self.progressBar stopAnimation:self];
}

@end
