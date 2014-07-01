//
//  SnoozeLocalNotificationTests.m
//  SnoozeLocalNotificationTests
//
//  Created by azu on 07/01/2014.
//  Copyright (c) 2014 azu. All rights reserved.
//

SPEC_BEGIN(InitialTests)

describe(@"My initial tests", ^{

  context(@"will fail", ^{

      it(@"can do maths", ^{
          [[theValue(1) should] equal:theValue(2)];
      });

      it(@"can read", ^{
          [[@"number" should] equal:@"string"];
      });
    
      it(@"will wait and fail", ^{
          NSObject *object = [[NSObject alloc] init];
          [[object shouldEventually] receive:@selector(autoContentAccessingProxy)];
      });
  });

  context(@"will pass", ^{
    
      it(@"can do maths", ^{
        [[theValue(1) should] beLessThan:theValue(23)];
      });
    
      it(@"can read", ^{
          [[@"team" shouldNot] containString:@"I"];
      });  
  });
  
});

SPEC_END
