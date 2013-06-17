//
//  AFNetworkingNocillaTests.m
//  AFNetworkingNocillaTests
//
//  Created by Raphael Oliveira on 6/16/13.
//  Copyright (c) 2013 Raphael Oliveira. All rights reserved.
//

#import "AFNetworkingNocillaTests.h"
#import "AFNetworking.h"
#import "Nocilla.h"

@implementation AFNetworkingNocillaTests

- (void)setUp
{
    [super setUp];
    [[LSNocilla sharedInstance] start];
    [[LSNocilla sharedInstance] clearStubs];
}

- (void)testStubSimpleRequest
{
    __block BOOL placeMarkUpdated = NO;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *dataSetPath = [bundle pathForResource:@"testStubSimpleRequest" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:dataSetPath];

    stubRequest(@"GET", @"http://api.openweathermap.org/data/2.5/weather?q=London,uk").andReturnRawResponse(jsonData).withHeaders(@{@"Content-Type": @"application/json"});
    
    NSURL *url = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=London,uk"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json)
    {
        NSNumber *lon = [json valueForKeyPath:@"coord.lon"];
        STAssertEqualObjects(lon, @10.10101, @"lon should be equal to 10.10101!");
        placeMarkUpdated = YES;
    }
    failure:nil];
    
    [operation start];
    
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !placeMarkUpdated);
}

- (void)tearDown
{
    [super tearDown];
    [[LSNocilla sharedInstance] stop];
}

@end
