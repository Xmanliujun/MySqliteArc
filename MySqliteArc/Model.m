//
//  Model.m
//  PlusTimesPang
//
//  Created by kimpeng on 13-4-10.
//
//

#import "Model.h"

@implementation Model

-(NSString*) getString:(sqlite3_stmt*)statement columnIndex:(NSInteger)index nullValue:(NSString *)nullValue
{
	if (sqlite3_column_type(statement, index) == SQLITE_NULL) {
		return nullValue;
	}
	
	NSString* value = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, index)];
	if(value == nil) {
		return nullValue;
	}
	
	return value;
}

-(NSNumber*) getInteger:(sqlite3_stmt *)statement columnIndex:(NSInteger)index nullValue:(NSNumber*)nullValue
{
	if (sqlite3_column_type(statement, index) == SQLITE_NULL) {
		return nullValue;
	}
	
	NSNumber* value = [NSNumber numberWithDouble:sqlite3_column_int( statement, index )];
	if(value == nil) {
		return nullValue;
	}
	
	return value;
}

-(NSNumber*) getDouble:(sqlite3_stmt *)statement columnIndex:(NSInteger)index nullValue:(NSNumber *)nullValue
{
	if (sqlite3_column_type(statement, index) == SQLITE_NULL) {
		return nullValue;
	}
	
	NSNumber* value = [NSNumber numberWithDouble:sqlite3_column_double( statement, index )];
	if(value == nil) {
		return nullValue;
	}
	
	return value;
}

-(NSDate*) getDate:(sqlite3_stmt*)statement columnIndex:(NSInteger)index nullValue:(NSDate *)nullValue
{
	NSString* dateStr = [self getString:statement columnIndex:index nullValue:nil];
	if (dateStr == nil) {
		return nullValue;
	}
	
	NSDate* value = [INUtility convertDate:dateStr format:DATE_FORMAT_STYLE];
	if(value == nil) {
		return nullValue;
	}
	
	return value;
}

-(NSDate*) getDatetime:(sqlite3_stmt*)statement columnIndex:(NSInteger)index nullValue:(NSDate *)nullValue
{
	NSString* dateStr = [self getString:statement columnIndex:index nullValue:nil];
	if (dateStr == nil) {
		return nullValue;
	}
	
	NSDate* value = [INUtility convertDate:dateStr format:DATETIME_FORMAT_STYLE_LONG];
	if(value == nil) {
		return nullValue;
	}
	
	return value;
}

-(NSString*) getString:(sqlite3_stmt*)statement columnIndex:(NSInteger)index
{
	if (sqlite3_column_type(statement, index) == SQLITE_NULL) {
		return nil;
	}
	return [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, index)];
}

-(NSInteger) getInteger:(sqlite3_stmt *)statement columnIndex:(NSInteger)index
{
	if (sqlite3_column_type(statement, index) == SQLITE_NULL) {
		return INT_NULL;
	}
	return sqlite3_column_int( statement, index );
}

-(NSDate*) getDate:(sqlite3_stmt*)statement columnIndex:(NSInteger)index
{
	NSString* dateStr = [self getString:statement columnIndex:index];
	if (dateStr == nil) {
		return nil;
	}
	
	return [INUtility convertDate:dateStr format:DATE_FORMAT_STYLE];
}

-(NSDate*) getDatetime:(sqlite3_stmt*)statement columnIndex:(NSInteger)index
{
	NSString* dateStr = [self getString:statement columnIndex:index];
	if (dateStr == nil) {
		return nil;
	}
	
	return [INUtility convertDate:dateStr format:DATETIME_FORMAT_STYLE_LONG];
}

-(BOOL) getBoolean:(sqlite3_stmt*)statement columnIndex:(NSInteger)index
{
	NSInteger value = [self getInteger:statement columnIndex:index];
	
	if (value == 1) {
		return YES;
	}
	
	return NO;
}



-(NSData*) getBinary:(sqlite3_stmt*)statement columnIndex:(NSInteger)index length:(NSNumber*)length
{
	if (sqlite3_column_type(statement, index) == SQLITE_NULL) {
		return nil;
	}
	if(length == nil) {
		return nil;
	}
	
	return [NSData dataWithBytes:sqlite3_column_blob(statement, index) length:[length unsignedIntegerValue]];
}



-(void)setText:(sqlite3_stmt *)statement string:(NSString*)string index:(int)index
{
	if(string != nil) {
		sqlite3_bind_text(statement, index, [string.description UTF8String], -1, 0);
	}
	else {
		sqlite3_bind_null(statement, index);
	}
}



-(void)setText:(sqlite3_stmt *)statement number:(NSNumber*)number index:(int)index
{
	if(number != nil) {
		[self setText:statement string:[number stringValue] index:index];
	}
	else {
		sqlite3_bind_null(statement, index);
	}
}



-(void)setInteger:(sqlite3_stmt *)statement number:(NSNumber*)number index:(int)index
{
	if(number != nil) {
		sqlite3_bind_int(statement, index, [number intValue]);
	}
	else {
		sqlite3_bind_null(statement, index);
	}
}



-(void)setInteger:(sqlite3_stmt *)statement integer:(NSInteger)integer index:(int)index
{
	NSNumber* number = [[NSNumber alloc] initWithInteger:integer];
	[self setInteger:statement number:number index:index];
}



-(void)setBinary:(sqlite3_stmt *)statement data:(NSData*)data index:(int)index
{
	if(data != nil) {
		sqlite3_bind_blob(statement, index, [data bytes], [data length], 0);
	}
	else {
		sqlite3_bind_null(statement, index);
	}
}


-(void)setBinary:(sqlite3_stmt *)statement image:(UIImage*)image index:(int)index
{
	if(image != nil) {
		NSData* data = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
		[self setBinary:statement data:data index:index];
	}
	else {
		sqlite3_bind_null(statement, index);
	}
}


-(BOOL)saveImage:(NSString*)fileName file:(UIImage*)file
{
	if(fileName == nil) {
		return NO;
	}
	
	NSString* storePath = [self getImageStoreDirectoryPath];
	NSError* error = nil;
	[[NSFileManager defaultManager] createDirectoryAtPath:storePath withIntermediateDirectories:YES attributes:nil error:&error];
	if(error == nil) {
		NSData* saveImage = UIImageJPEGRepresentation(file, 1.0);
		[saveImage writeToFile:[storePath stringByAppendingPathComponent:fileName] atomically:YES];
		
		return YES;
	}
	
	return NO;
}


-(NSString*)getImageStoreDirectoryPath
{
    //	return [INUtility getDocumentPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/photo", NSHomeDirectory()] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/photo"];
    return path;
}

-(sqlite3*)openDatabase
{
	return [[DatabaseConfiguration instance] openDatabase];
}

-(void)closeDatabase
{
	[[DatabaseConfiguration instance] closeDatabase];
}

-(void) beginTransaction
{
	[[DatabaseConfiguration instance] beginTransaction];
}

-(void) commitTransaction
{
	[[DatabaseConfiguration instance] commitTransaction];
}

-(void) rollbackTransaction
{
	[[DatabaseConfiguration instance] rollbackTransaction];
}

@end

