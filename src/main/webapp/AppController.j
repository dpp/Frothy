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
  CPTextField label;
  CPTextField input;
  CPTextField clock;
  + AppController controllerInstance;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  AppController.controllerInstance = self;
  var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
    contentView = [theWindow contentView];

  label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];

  [label setStringValue:@"Hello World!"];
  [label setFont:[CPFont boldSystemFontOfSize:24.0]];
  [label setAlignment:CPCenterTextAlignment]; 
  [label sizeToFit];

  [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
  [label setCenter:[contentView center]];

  [contentView addSubview:label];
 
  input = [[CPTextField alloc] initWithFrame: CGRectMake(
							 CGRectGetWidth([contentView bounds])/2.0 - 350,
							 CGRectGetMaxY([label frame]) + 10,
							 80, 24
							 )];

  [input setStringValue:@"Send me to the server"];
  [input setFont:[CPFont boldSystemFontOfSize:18.0]];

  [input sizeToFit];

  [input setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
  [input setEditable: YES];
  [input setBezeled: YES];

  [contentView addSubview:input];

  var button = [[CPButton alloc] initWithFrame: CGRectMake(
							   CGRectGetWidth([contentView bounds])/2.0 - 40,
							   CGRectGetMaxY([label frame]) + 10,
							   80, 24
							   )];
                          
  [button setAutoresizingMask:CPViewMinXMargin | 
	  CPViewMaxXMargin | 
	  CPViewMinYMargin | 
	  CPViewMaxYMargin];

  [button setTitle:"Click Me"];

  [button setTarget:self];
  [button setAction:@selector(swap:)];                
              
  [contentView addSubview:button];

  clock = [[CPTextField alloc] initWithFrame:CGRectMake(
							CGRectGetWidth([contentView bounds])/2.0 - 100,
							CGRectGetMaxY([label frame]) + 40,
							80, 24
							)];

  [clock setStringValue:@""];
  [clock setFont:[CPFont boldSystemFontOfSize:24.0]];

  [clock sizeToFit];

  [clock setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
  [clock setAlignment:CPCenterTextAlignment];
  [contentView addSubview:clock];


  [theWindow orderFront:self];

  // Uncomment the following line to turn on the standard menu bar.
  // [CPMenu setMenuBarVisible:YES];
}

- (void)swap:(id)sender
{
  performAjaxCall([input stringValue]);
  [input setStringValue: ""];

  if ([label stringValue] == "Hello World!")
    [label setStringValue:"Goodbye!"];
  else
    [label setStringValue:"Hello World!"];
}

- (id)buttonCallback:(id)what {
  [label setStringValue:what];
  [label sizeToFit];
  return self;
}

- (id)clockCallback:(id)what {
  [clock setStringValue:what];
  [clock sizeToFit];
  return self;
}

@end

function ajaxCallback(what) {
  [AppController.controllerInstance buttonCallback: what];
}

function clockCallback(time) {
  [AppController.controllerInstance clockCallback: time];
}
