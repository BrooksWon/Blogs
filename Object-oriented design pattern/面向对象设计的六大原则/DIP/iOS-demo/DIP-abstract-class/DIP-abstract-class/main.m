//
//  main.m
//  DIP-abstract-class
//
//  Created by Brooks on 2019/5/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Project.h"
#import "FrondEndDeveloper.h"
#import "BackEndDeveloper.h"
#import "IOSDeveloper.h"
#import "AndroidDeveloper.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        FrondEndDeveloper *fe = FrondEndDeveloper.new;
        BackEndDeveloper *be = BackEndDeveloper.new;
        IOSDeveloper *ios = IOSDeveloper.new;
        AndroidDeveloper *android = AndroidDeveloper.new;
        
        Project *p = [[Project alloc] initWithDevelopers:@[fe,be,ios,android]];
        [p startDeveloping];
    }
    return 0;
}
