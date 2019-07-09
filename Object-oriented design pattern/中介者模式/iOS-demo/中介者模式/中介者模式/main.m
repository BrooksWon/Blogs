//
//  main.m
//  中介者模式
//
//  Created by Brooks on 2019/6/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "ChatMediator.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        ChatMediator *cm = [[ChatMediator alloc] init];
        
        User *user1 = [[User alloc] initWithName:@"Jack" mediator:cm];
        User *user2 = [[User alloc] initWithName:@"Bruce" mediator:cm];
        User *user3 = [[User alloc] initWithName:@"Lucy" mediator:cm];
        
        [cm addUser:user1];
        [cm addUser:user2];
        [cm addUser:user3];
        
        [user1 sendMessage:@"happy"];
        [user2 sendMessage:@"new"];
        [user3 sendMessage:@"year"];
    }
    return 0;
}
