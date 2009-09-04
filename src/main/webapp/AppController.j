/*
 * AppController.j
 * NewApplication
 *
 * Created by You on July 5, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation AppController : CPObject
{
    MessageView messageView;
    CPTextField input;
    CPTextField clock;
    // + AppController controllerInstance;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    AppController.controllerInstance = self;
    
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView],
        bounds = [contentView bounds];

    [contentView setBackgroundColor:[CPColor colorWithWhite:0.85 alpha:1.0]];

    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds) - 40)];
    
    [scrollView setHasHorizontalScroller:NO];

    messageView = [[MessageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds), 0)];
    
    [messageView setAutoresizingMask:CPViewWidthSizable];
    
    [scrollView setDocumentView:messageView];
    
    [scrollView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];

    [contentView addSubview:scrollView];
    
    
    [scrollView setBackgroundColor:[CPColor whiteColor]];
    [messageView setBackgroundColor:[CPColor whiteColor]];
    
    
    label = [CPTextField labelWithTitle:@"Hello World!"];

    [label setAlignment:CPCenterTextAlignment]; 

    [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [label setCenter:[contentView center]];
 
    input = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"Send a message to the server..." width:CGRectGetWidth(bounds) - 145];

    [input setFrameOrigin:CGPointMake(10, CGRectGetHeight(bounds) - CGRectGetHeight([input bounds]) - 4)];
    [input setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];

    [input setTarget:self];
    [input setAction:@selector(send:)];
    
    [contentView addSubview:input];

    var button = [[CPButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) - 125, CGRectGetHeight(bounds) - 31, 110, 24)];
                          
    [button setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
    [button setTitle:"Send"];

    [button setTarget:self];
    [button setAction:@selector(send:)];                
              
    [contentView addSubview:button];

    [theWindow setDefaultButton:button];

    clock = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) - 250 - [CPScroller scrollerWidth], 0, 250, 22)];

    [clock setFont:[CPFont systemFontOfSize:14.0]];
    [clock setBackgroundColor:[CPColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.3]];
    [clock setAutoresizingMask:CPViewMinXMargin];
    [clock setAlignment:CPCenterTextAlignment];

    [contentView addSubview:clock];
    
    [theWindow orderFront:self];
}

- (void)send:(id)sender
{
    performAjaxCall([input stringValue]);
    [input setStringValue:""];
}

- (id)buttonCallback:(id)what 
{
    [messageView addMessage:what];
    [messageView scrollPoint:CGPointMake(0, [messageView frame].size.height)];
    
    return self;
}

- (id)clockCallback:(id)what
{
    [clock setStringValue:what];
    return self;
}

@end

@implementation MessageView : CPView
{
    CPArray messages;
}

- (void)addMessage:(CPString)aMessage
{
    [messages addObject:aMessage];
    
    var size = [self frame].size;
    [self setFrameSize:CGSizeMake(size.width, size.height + 30)];

    var label = [[CPTextField alloc] initWithFrame:CGRectMake(5, size.height + 5, size.width - 10, 20)];
    [label setAutoresizingMask:CPViewWidthSizable];
    
    [label setStringValue:aMessage];

    [self addSubview:label];
}

@end

function ajaxCallback(what) {
  [AppController.controllerInstance buttonCallback:what];
}

function clockCallback(time) {
  [AppController.controllerInstance clockCallback:time];
}
