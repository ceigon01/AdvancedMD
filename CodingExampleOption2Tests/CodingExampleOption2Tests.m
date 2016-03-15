//
//  CodingExampleOption2Tests.m
//  CodingExampleOption2Tests
//
//  Created by Jason Smith on 1/27/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DashboardViewController.h"

@interface CodingExampleOption2Tests : XCTestCase

@end

@implementation CodingExampleOption2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//not actually implemented but just an example of comparing array values using unit testing 
-(void)testColorSequenceWithMockData:(NSMutableArray*)arrayToTest{
    NSArray *mockDataArray =[ [NSMutableArray alloc]initWithObjects:[UIColor redColor], nil];
    XCTAssertEqualObjects(mockDataArray, arrayToTest);
}

- (void)testColorSequence {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSMutableArray *testValueArray = [[NSMutableArray alloc]initWithObjects:[UIColor redColor], nil];
    [self testColorSequenceWithMockData:testValueArray];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
