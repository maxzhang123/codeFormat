//
//  HandleFormatCodeMethod.h
//  FormatCode
//
//  Created by Max on 2016/12/23.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XcodeKit.h> 

@interface HandleFormatCodeMethod : NSObject

@property (strong, nonatomic) NSMutableArray *allLinesCodeMArr;
@property (strong, nonatomic) XCSourceEditorCommandInvocation *invocation;




/**
 处理implementation之后所有的换行
 */
- (void)handlEunnecessaryNewLine;

/**
 处理成第一个#import之前必须有唯一的一个换行
 */
- (void)handleBeforeFirstImportHasOnlyOneNewLine;


/**
 处理最后一个#import与第一个interface之间仅保留一个换行
 */
- (void)handleBetweenTheLastImportAndNextCodeHasOnlyOneNewLine;


/**
 处理interface前只有一个换行
 */
- (void)handleBefroreInterfaceHasOnlyOneNewLine;


/**
 处理interface后只有一个换行
 */
- (void)handleLaterInterfaceHasOnlyOneNewLine;


/**
 处理implementation前只有一个换行
 */
- (void)handleBefroreImplementationHasOnlyOneNewLine;


/**
 处理implementation后只有一个换行
 */
- (void)handleLaterImplementationHasOnlyOneNewLine;


/**
 处理end前只有一个换行
 */
- (void)handleBefroreEndHasOnlyOneNewLine;


/**
 处理end后只有一个换行
 */
- (void)handleLaterEndHasOnlyOneNewLine;


/**
 处理每个方法前仅有2个换行  处理每个方法后仅有2个换行
 */
- (void)handleBeforeEveryMethodAndLaterEveryMethodHasOnlyTwoNewLine;


/**
 处理每个方法开始的第一个花括号另起一行
 */
- (void)handleMethodStartLocationTheFirstBraceNewLine;


/**
 处理@property属性申明时候的间距
 */
- (void)handlePropertyLineSpaceMargin;



/**
 处理#pragma 或者 #warning前后各空一行
 */
- (void)handleBeforeAndLaterPragmaOrWarningHasNewLine;


@end
