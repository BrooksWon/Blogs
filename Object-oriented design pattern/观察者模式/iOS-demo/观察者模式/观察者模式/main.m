//
//  main.m
//  观察者模式
//
//  Created by Brooks on 2019/6/5.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinancialAdviser.h"
#import "Investor.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        FinancialAdviser *fa = [[FinancialAdviser alloc] init];
        
        Investor *iv1 = [[Investor alloc] initWithSubject:fa];
        
        NSLog(@"====== first advice ========");
        [fa setBuyingPrice:1.3];
        
        
        Investor *iv2 = [[Investor alloc] initWithSubject:fa];
        Investor *iv3 = [[Investor alloc] initWithSubject:fa];
        
        NSLog(@"====== second advice ========");
        [fa setBuyingPrice:2.6];
        
        [fa addObserver:iv3];
        [fa addObserver:iv3];
        [fa addObserver:iv3];
        
        NSLog(@"====== 3 advice ========");
        [fa setBuyingPrice:2.6];
        
        /**
         
         hashTable、NSMapTable
         */
        

//        NSHashTable *hashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsCopyIn];
//        [hashTable addObject:@"foo"];
//        [hashTable addObject:@"bar"];
//        [hashTable addObject:@42];
//        [hashTable removeObject:@"bar"];
//        NSLog(@"Members: %@", [hashTable allObjects]);
//        NSLog(@"====== second advice ========");
//        NSDictionary,key必须是符合NSCopying协议的，value被强引用，
//        NSArray中的对象被强引用
//
//        NSMapTable *mapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
//                                                    valueOptions:NSMapTableWeakMemory];
//        [mapTable setObject:@"哈哈😆" forKey:@"foo"];
//        NSLog(@"Keys: %@", [[mapTable keyEnumerator] allObjects]);
    }
    return 0;
}
