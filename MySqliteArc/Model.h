//
//  Model.h
//  PlusTimesPang
//
//  Created by kimpeng on 13-4-10.
//
//

#import <Foundation/Foundation.h>
#import "DatabaseConfiguration.h"
#import "sqlite3.h"
#import "INUtility.h"
#import "CONST.h"

@interface Model : NSObject

-(sqlite3*)openDatabase;

-(void)closeDatabase;

-(void) beginTransaction;

-(void) commitTransaction;

-(void) rollbackTransaction;

-(void)setText:(sqlite3_stmt *)statement string:(NSString*)string index:(int)index;

-(void)setText:(sqlite3_stmt *)statement number:(NSNumber*)number index:(int)index;

-(void)setInteger:(sqlite3_stmt *)statement number:(NSNumber*)number index:(int)index;

-(void)setInteger:(sqlite3_stmt *)statement integer:(NSInteger)integer index:(int)index;

-(void)setBinary:(sqlite3_stmt *)statement data:(NSData*)data index:(int)index;

-(void)setBinary:(sqlite3_stmt *)statement image:(UIImage*)image index:(int)index;

-(NSString*) getString:(sqlite3_stmt*)statement columnIndex:(NSInteger)index nullValue:(NSString*)nullValue;

-(NSNumber*) getInteger:(sqlite3_stmt *)statement columnIndex:(NSInteger)index nullValue:(NSNumber*)nullValue;

-(NSNumber*) getDouble:(sqlite3_stmt *)statement columnIndex:(NSInteger)index nullValue:(NSNumber*)nullValue;

-(NSDate*) getDate:(sqlite3_stmt*)statement columnIndex:(NSInteger)index nullValue:(NSDate*)nullValue;

-(NSDate*) getDatetime:(sqlite3_stmt*)statement columnIndex:(NSInteger)index nullValue:(NSDate*)nullValue;

-(NSString*) getString:(sqlite3_stmt*)statement columnIndex:(NSInteger)index;

-(NSInteger) getInteger:(sqlite3_stmt *)statement columnIndex:(NSInteger)index;

-(NSDate*) getDate:(sqlite3_stmt*)statement columnIndex:(NSInteger)index;

-(NSDate*) getDatetime:(sqlite3_stmt*)statement columnIndex:(NSInteger)index;

-(BOOL) getBoolean:(sqlite3_stmt*)statement columnIndex:(NSInteger)index;

-(NSData*) getBinary:(sqlite3_stmt*)statement columnIndex:(NSInteger)index length:(NSNumber*)length;

-(BOOL)saveImage:(NSString*)fileName file:(UIImage*)file;

-(NSString*)getImageStoreDirectoryPath;

@end

