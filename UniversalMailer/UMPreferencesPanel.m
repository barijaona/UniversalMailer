//
//  UMPreferencesPanel.m
//  UniversalMailer
//
//  Created by luca on 25/05/16.
//  Copyright © 2017 noware. All rights reserved.
//

#import "UMPreferencesPanel.h"

#import "UMConstants.h"

@interface UMPreferencesPanel ()
@property (weak) IBOutlet NSTextField *logWarningLabel;
@property (weak) IBOutlet NSTextField *fontPreviewLabel;
@property (weak) IBOutlet NSColorWell *fontColorWell;
@property (weak) IBOutlet NSTextField *versionLabel;
@property (weak) IBOutlet NSTextField *logFilePathLabel;
@property (unsafe_unretained) IBOutlet UMTextView *injectedCSSLabel;
@property (weak) IBOutlet NSTextField *fontNAInfoLabel;
@property (weak) IBOutlet NSTextField *lastUpdateLabel;
@property (unsafe_unretained) IBOutlet UMTextView *injectedStyle;
@end

@implementation UMPreferencesPanel

- (id)preferencesNibName {
    return @"UMPreferencesPanelUI";
}

- (id)imageForPreferenceNamed:(id)fp8 {
    NSString *iconPath = [[NSBundle bundleForClass: [self class]] pathForResource: @"UniversalMailerIcon" ofType: @"png"];
    return [[NSImage alloc] initWithContentsOfFile: iconPath];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if( self.logWarningLabel ){
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString: self.logWarningLabel.stringValue];
        NSRange wr = [as.string rangeOfString: @"WARNING"];
        [as addAttributes: @{NSFontAttributeName: [NSFont boldSystemFontOfSize: self.logWarningLabel.font.pointSize]} range: wr];
        if( as.length > 0 )
            self.logWarningLabel.attributedStringValue = as;
    }
    if( self.fontPreviewLabel ){
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: UMOutgoingFontColor];
        NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey: UMOutgoingFontName];
        CGFloat size = [[NSUserDefaults standardUserDefaults] floatForKey: UMOutgoingFontSize];
        if( colorData && name.length > 0 && size > 0 ){
            NSFont *font = [NSFont fontWithName: name size: size];
            CGFloat ssize = self.fontPreviewLabel.font.pointSize;
            NSFont *sfont = [NSFont fontWithName: font.fontName size: ssize];
            self.fontPreviewLabel.font = sfont;
            self.fontPreviewLabel.stringValue = [NSString stringWithFormat: @"%@ - %.1f", font.fontName, font.pointSize];

            NSColor *color = [[NSColor blackColor] colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
            color = [[NSUnarchiver unarchiveObjectWithData: colorData] colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
            self.fontPreviewLabel.textColor = color;
            self.fontColorWell.color = color;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self _adjustFontPreviewSize];
            });
        }
    }
    if( self.versionLabel ){
        NSBundle *bundle = [NSBundle bundleForClass: [self class]];
        NSString *shortVersion = [bundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString *build = [bundle objectForInfoDictionaryKey: (NSString*)kCFBundleVersionKey];
        self.versionLabel.stringValue = [NSString stringWithFormat: @"Version: %@\n(build %@)", shortVersion, build];
    }
    if( self.injectedCSSLabel ){
        self.injectedCSSLabel.umDelegate = self;
        NSString *injectedCSS = [[NSUserDefaults standardUserDefaults] objectForKey: UMInjectedCSS];
        if( injectedCSS.length < 1 )
            [self.injectedCSSLabel setTextColor: [NSColor disabledControlTextColor]];
        else
            self.injectedCSSLabel.string = injectedCSS;
    }
    if( self.injectedStyle ){
        self.injectedStyle.umDelegate = self;
        NSString *injectedStyle = [[NSUserDefaults standardUserDefaults] objectForKey: UMInjectedStyle];
        if( injectedStyle.length < 1 )
            [self.injectedStyle setTextColor: [NSColor disabledControlTextColor]];
        else
            self.injectedStyle.string = injectedStyle;
    }
    if( self.lastUpdateLabel ){
        SUUpdater *updater = [SUUpdater updaterForBundle: [NSBundle bundleForClass: [self class]]];
        if( updater.lastUpdateCheckDate ){
            NSString *lastUpdate = [NSDateFormatter localizedStringFromDate: updater.lastUpdateCheckDate dateStyle: NSDateFormatterShortStyle timeStyle: NSDateFormatterShortStyle];
            self.lastUpdateLabel.stringValue = [NSString stringWithFormat: @"Last check: %@", lastUpdate];
        }
        else {
            self.lastUpdateLabel.stringValue = @"Last check: never";
        }
    }
}

- (IBAction)donatePressed:(id)sender {
    NSWorkspace * ws = [NSWorkspace sharedWorkspace];
    NSURL * url = [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=X4NT6BB7DARBA"];
    [ws openURL: url];
}

- (IBAction)selectColorPressed:(id)sender {
    [[NSColorPanel sharedColorPanel] setColor: self.fontColorWell.color];
    [[NSColorPanel sharedColorPanel] setTarget: self];
    [[NSColorPanel sharedColorPanel] setAction: @selector(selectedColor:)];
    [[NSColorPanel sharedColorPanel] makeKeyAndOrderFront: self];
}

- (IBAction)selectFontPressed:(id)sender {
    [[NSFontPanel sharedFontPanel] setDelegate: self];
    [[NSFontPanel sharedFontPanel] setEnabled: YES];
    [[NSFontPanel sharedFontPanel] makeKeyAndOrderFront: self];
    
    [[NSFontManager sharedFontManager] setAction: @selector(selectedFont:)];
    [[NSFontManager sharedFontManager] setSelectedFont: self.fontPreviewLabel.font isMultiple: NO];
}

- (IBAction)injectOverrideSelected:(NSButton*)sender {
    if( [sender state] ){
        [self.injectedCSSLabel setTextColor: [NSColor controlTextColor]];
    }
    else {
        [self.injectedCSSLabel setTextColor: [NSColor disabledControlTextColor]];
    }
}

- (IBAction)checkForUpdatePressed:(id)sender {
    SUUpdater *updater = [SUUpdater updaterForBundle: [NSBundle bundleForClass: [self class]]];
    updater.delegate = self;
    [updater checkForUpdates: sender];
}

#pragma mark -
#pragma mark SUUpdaterDelegate methods

- (void)updater: (SUUpdater*)updater didFindValidUpdate: (SUAppcastItem*)update {
    NSString *lastUpdate = [NSDateFormatter localizedStringFromDate: updater.lastUpdateCheckDate dateStyle: NSDateFormatterShortStyle timeStyle: NSDateFormatterShortStyle];
    self.lastUpdateLabel.stringValue = [NSString stringWithFormat: @"Last check: %@", lastUpdate];
}

- (void)updaterDidNotFindUpdate: (SUUpdater*)updater {
    NSString *lastUpdate = [NSDateFormatter localizedStringFromDate: updater.lastUpdateCheckDate dateStyle: NSDateFormatterShortStyle timeStyle: NSDateFormatterShortStyle];
    self.lastUpdateLabel.stringValue = [NSString stringWithFormat: @"Last check: %@", lastUpdate];
}


#pragma mark -
#pragma mark Action handlers

- (void)selectedFont: (id)sender {
    CGFloat size = self.fontPreviewLabel.font.pointSize;
    NSFont *font = [sender convertFont: self.fontPreviewLabel.font];
    
    if( font ){
        [[NSUserDefaults standardUserDefaults] setObject: font.fontName forKey: UMOutgoingFontName];
        [[NSUserDefaults standardUserDefaults] setFloat: font.pointSize forKey: UMOutgoingFontSize];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSFont *sfont = [NSFont fontWithName: font.fontName size: size];
        self.fontPreviewLabel.font = sfont;
        self.fontPreviewLabel.stringValue = [NSString stringWithFormat: @"%@ - %.1f", font.fontName, font.pointSize];

        [self _adjustFontPreviewSize];
    }
}

- (void)selectedColor: (NSColorPanel*)sender {
//    Class pref = NSClassFromString( @"NSPreferences" );
//    id currentModule = [[pref sharedPreferences] valueForKey: @"_currentModule"];
//    id kWindow = [NSApp keyWindow];
//    id lWindow = [[pref sharedPreferences] valueForKey: @"_preferencesPanel"];
//    if( currentModule == self && ([NSColorPanel sharedColorPanel] == kWindow || lWindow == kWindow) ){

    self.fontPreviewLabel.textColor = sender.color;
    NSData *colorData = [NSArchiver archivedDataWithRootObject: [sender.color colorUsingColorSpaceName: NSCalibratedRGBColorSpace]];
    [[NSUserDefaults standardUserDefaults] setObject: colorData forKey: UMOutgoingFontColor];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

#pragma mark -
#pragma mark Private methods

- (void)_adjustFontPreviewSize {
    CGFloat oldY = self.fontPreviewLabel.frame.origin.y;
    CGFloat oldWidth = self.fontPreviewLabel.frame.size.width;
    CGFloat oldHeight = self.fontPreviewLabel.frame.size.height;
    [self.fontPreviewLabel sizeToFit];
    CGRect f = self.fontPreviewLabel.frame;
    f.origin.y = oldY-(self.fontPreviewLabel.frame.size.height-oldHeight);
    f.size.width = oldWidth;
    self.fontPreviewLabel.frame = f;
    [self.fontPreviewLabel setNeedsLayout: YES];
}

#pragma mark -
#pragma mark UMTextViewDelegate methods

- (void)textChanged: (UMTextView*)textView {
    if( textView.string ){
        if( textView == self.injectedStyle ){
            [[NSUserDefaults standardUserDefaults] setObject: textView.string forKey: UMInjectedStyle];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if( textView == self.injectedCSSLabel ){
            [[NSUserDefaults standardUserDefaults] setObject: textView.string forKey: UMInjectedCSS];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end
