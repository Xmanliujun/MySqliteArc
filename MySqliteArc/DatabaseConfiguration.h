//
//  DatabaseConfiguration.h
//  PlusTimesPang
//
//  Created by kimpeng on 13-4-10.
//
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseConfiguration : NSObject
{
    sqlite3  *database;
    
    NSString *path;
    
    int transactionCount;
    
    BOOL     isOpen;
}

@property (nonatomic, readonly) sqlite3  *database;
@property (nonatomic, retain)   NSString *path;
@property int transactionCount;

+(id) instance;

-(sqlite3*) openDatabase;

-(void) closeDatabase;

-(void) beginTransaction;

-(void) commitTransaction;

-(void) rollbackTransaction;

@end

