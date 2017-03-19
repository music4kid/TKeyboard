//
//  MCManager.m
//  EasyText
//
//  Created by gao feng on 2016/10/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "MCManager.h"
#import "SessionContainer.h"
#if TARGET_OS_IOS
#import "ESharedUserDefault.h"
#endif


#define ServiceType @"srv-tkb-share"

@interface MCManager () <SessionContainerDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>
@property (retain, nonatomic) SessionContainer *sessionContainer;

@property (nonatomic, strong) NSString*                 displayName;
@property (nonatomic, strong) NSString*                 serviceType;

@property (nonatomic, strong) MCNearbyServiceBrowser*                 browser;
@property (nonatomic, strong) MCPeerID*                               myPeerID;
@property (nonatomic, strong) MCPeerID*                               syncPeerID;
@property (nonatomic, strong) MCSession*                              session;

@property (nonatomic, strong) MCNearbyServiceAdvertiser*                 advertiser;


@end

@implementation MCManager

+ (instancetype)sharedInstance
{
    static MCManager* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MCManager new];
    });

    return instance;
}

- (void)beginAdvertisingForiOS {
    NSString* deviceName = nil;
    #if TARGET_OS_IOS
    deviceName = [UIDevice currentDevice].name;
    #endif
    self.displayName = deviceName;
    self.serviceType = ServiceType;
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:_displayName];
    
    self.sessionContainer = [[SessionContainer alloc] initSessionForAdvertiser:_myPeerID];
    _sessionContainer.delegate = self;
    
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:nil serviceType:_serviceType];
    _advertiser.delegate = self;
    [_advertiser startAdvertisingPeer];
}

#pragma mark - MCNearbyServiceAdvertiserDelegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(nullable NSData *)context
 invitationHandler:(void (^)(BOOL accept, MCSession * __nullable session))invitationHandler
{
    if ([peerID.displayName isEqualToString:_myPeerID.displayName] == true) {
        return;
    }
    invitationHandler(true, _sessionContainer.session);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    
}

- (void)beginBrowsingForMac {
    #if TARGET_OS_OSX
    NSHost *host = [NSHost currentHost];
    self.displayName = [host localizedName];
    #endif
    self.serviceType = ServiceType;
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:_displayName];
    
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_myPeerID serviceType:_serviceType];
    _browser.delegate = self;
    
    self.sessionContainer = [[SessionContainer alloc] initSessionForBrowser:_myPeerID];
    _sessionContainer.delegate = self;
    
    [_browser startBrowsingForPeers];
}

#pragma mark - MCNearbyServiceBrowserDelegate
- (void)browser:(MCNearbyServiceBrowser *)browser
      foundPeer:(MCPeerID *)peerID
withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info
{
    if ([peerID.displayName isEqualToString:_myPeerID.displayName] == true) {
        return;
    }
#if TARGET_OS_OSX
    [_browser invitePeer:peerID toSession:_sessionContainer.session withContext:nil timeout:60];
#endif
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    
}

#pragma mark - SessionContainerDelegate
- (void)receivedTranscript:(Transcript *)transcript {
    if (self.delegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (transcript.imageUrl != nil) {
                //begin receive image
//                [_delegate didReceiveImage:transcript.imageUrl];
            }
            else
            {
                [_delegate didReceiveText:transcript.message];
            }
            
        });
    }
}

- (void)updateTranscript:(Transcript *)transcript {
    if (self.delegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (transcript.direction == TRANSCRIPT_DIRECTION_SEND) {
                [_delegate didSentImage:transcript.imageUrl];
            }
            else if (transcript.direction == TRANSCRIPT_DIRECTION_RECEIVE) {
                [_delegate didReceiveImage:transcript.imageUrl];
            }  
        });
    }
}

- (void)onPeerStateChanged:(MCSessionState)state peer:(MCPeerID *)peer {
    if (self.delegate) {
        
        NSLog(@"Peer State: %ld", state);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate onPeerStateUpdate:state host:peer.displayName];
            if (state == MCSessionStateConnected) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_MCPeer_Connected object:peer.displayName];
                });
            }
        });
        
    }
}

- (Transcript *)sendMessage:(NSString *)message {
    if ([self isConnectionAvailable] == false) {
        NSLog(@"no peer is connected");
    }
    return [self.sessionContainer sendMessage:message];
}

- (Transcript *)sendImage:(NSURL *)imageUrl {
    if ([self isConnectionAvailable] == false) {
        NSLog(@"no peer is connected");
    }
    return [self.sessionContainer sendImage:imageUrl];
}

- (BOOL)isConnectionAvailable
{
    return self.sessionContainer.session.connectedPeers.count > 0;
}

- (NSArray*)getConnectedPeers {
    NSMutableArray* peers = @[].mutableCopy;
    
    for (MCPeerID* peer in self.sessionContainer.session.connectedPeers) {
        if (peer.displayName.length > 0) {
            [peers addObject:peer.displayName];
        }
    }
    return peers;
}

- (void)dealloc
{
    [_browser stopBrowsingForPeers];
}

@end
