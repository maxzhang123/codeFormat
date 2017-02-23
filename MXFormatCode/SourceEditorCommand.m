//
//  SourceEditorCommand.m
//  MXFormatCode
//
//  Created by Max on 2016/12/22.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "HandleFormatCodeMethod.h"

@interface SourceEditorCommand ()

@property (strong, nonatomic) NSMutableArray *allLinesCodeMArr;
@property (strong, nonatomic) HandleFormatCodeMethod *codeMethod;

@end



@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
//    [self handleLLVMStyleFormatWithInvocation:invocation completionHandler:completionHandler];
    
    [self formatAllClassFileCode:invocation];
    completionHandler(nil);
}


- (NSMutableArray *)allLinesCodeMArr
{
    if (!_allLinesCodeMArr) {
        _allLinesCodeMArr = [NSMutableArray array];
    }
    return _allLinesCodeMArr;
}


- (HandleFormatCodeMethod *)codeMethod
{
    if (!_codeMethod) {
        _codeMethod = [[HandleFormatCodeMethod alloc] init];
    }
    return _codeMethod;
}


- (void)formatAllClassFileCode:(XCSourceEditorCommandInvocation *)invocation
{
    if (invocation.buffer.lines.count == 0) {
        return;
    }
    
    [self.allLinesCodeMArr removeAllObjects];
    //处理NSTaggedPointerString 转化为NSString
    for (int i = 0; i < invocation.buffer.lines.count; i++) {
        id stringValue = [invocation.buffer.lines objectAtIndex:i];
        id stringPointerValue = [stringValue mutableCopy];
        [_allLinesCodeMArr addObject:stringPointerValue];
    }
    
    self.codeMethod.allLinesCodeMArr = self.allLinesCodeMArr;
    self.codeMethod.invocation = invocation;
    
    //处理implementation之后所有的换行
    [self.codeMethod handlEunnecessaryNewLine];
    
    //处理#import之前要预留一行空格的问题
    [self.codeMethod handleBeforeFirstImportHasOnlyOneNewLine];
    
    //处理最后一个#import与第一个@interface之间仅保留一个换行
    [self.codeMethod handleBetweenTheLastImportAndNextCodeHasOnlyOneNewLine];

    //处理@interface前后都有一个换行
    [self.codeMethod handleBefroreInterfaceHasOnlyOneNewLine];
    [self.codeMethod handleLaterInterfaceHasOnlyOneNewLine];

    //处理implementation前后都有一个换行
    [self.codeMethod handleBefroreImplementationHasOnlyOneNewLine];
    [self.codeMethod handleLaterImplementationHasOnlyOneNewLine];
    
    //处理@end前后都有一个换行
    [self.codeMethod handleBefroreEndHasOnlyOneNewLine];
    [self.codeMethod handleLaterEndHasOnlyOneNewLine];
    
    //处理@property属性申明时候的间距
    [self.codeMethod handlePropertyLineSpaceMargin];
    
    //处理每个方法开始的第一个花括号另起一行
    [self.codeMethod handleMethodStartLocationTheFirstBraceNewLine];
    
    //处理每个方法前有2个换行 每个方法后有2个换行
    [self.codeMethod handleBeforeEveryMethodAndLaterEveryMethodHasOnlyTwoNewLine];
    
    //处理#pragma 或者 #warning前后各空一行
    [self.codeMethod handleBeforeAndLaterPragmaOrWarningHasNewLine];
    
}



- (void)handleLLVMStyleFormatWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"clang_format" ofType:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathStr]) {
        NSLog(@"=====fileExistsAtPath======");
    }
    
    
    NSPipe *errorPipe = [[NSPipe alloc] init];
    NSPipe *outputPipe = [[NSPipe alloc] init];
    NSPipe *inputPipe = [[NSPipe alloc] init];

    NSTask *task = [[NSTask alloc] init];
    task.standardError = errorPipe;
    task.standardOutput = outputPipe;
    task.launchPath = pathStr;
    task.arguments = @[@"-style=llvm"];
    task.standardInput = inputPipe;
    
    NSFileHandle *stdinHandle = inputPipe.fileHandleForWriting;
    
    NSString *stdin = invocation.buffer.completeBuffer;
    
    NSData *data = [stdin dataUsingEncoding:NSUTF8StringEncoding];
    [stdinHandle writeData:data];
    [stdinHandle closeFile];
    [task launch];
    [task waitUntilExit];
    [errorPipe.fileHandleForReading readDataToEndOfFile];
    NSData *outputData = [outputPipe.fileHandleForReading readDataToEndOfFile];
    NSString *resultStr = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    
    
    //--------------------------------------------
    if ([invocation.buffer.contentUTI isEqualToString:@"public.objective-c-source"]) {
        [invocation.buffer.lines removeAllObjects];
        NSArray *lines = [resultStr componentsSeparatedByString:@"\n"];
        [invocation.buffer.lines addObjectsFromArray:lines];
        [invocation.buffer.selections removeAllObjects];
        XCSourceTextRange *range = [[XCSourceTextRange alloc] init];
        range.start = XCSourceTextPositionMake(0, 0);
        range.end = XCSourceTextPositionMake(0, 0);
        [invocation.buffer.selections addObject:range];
    };
}


@end
