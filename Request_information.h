//
//  Request_information.h
//  Magazine
//
//  Created by Fstech on 3/5/13.
//  Copyright (c) 2013 Fstech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Request_information : UIViewController<UITextFieldDelegate>{

    
      IBOutlet UIScrollView *scrollViewForNewEvent;
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField * medical;
    
    IBOutlet UITextField * emailAddress;
    IBOutlet UITextField * Phone;
    
    IBOutlet UITextField * Address;
    IBOutlet UITextField * AddressLine2;
    IBOutlet UITextField * city;
    IBOutlet UITextField * state;
    IBOutlet UITextField *  zip;
    IBOutlet UITextField *  country;
    
    IBOutlet UIView *portraitView;
    IBOutlet UIView *landscapView;
    CGFloat animatedDistance;
    UIResponder *responder;
    
    
    
    
    
    IBOutlet UIScrollView *scrollViewForNewEvent1;
    IBOutlet UITextField *firstName1;
    IBOutlet UITextField *lastName1;
    IBOutlet UITextField * medical1;
    
    IBOutlet UITextField * emailAddress1;
    IBOutlet UITextField * Phone1;
    
    IBOutlet UITextField * Address1;
    IBOutlet UITextField * AddressLine21;
    IBOutlet UITextField * city1;
    IBOutlet UITextField * state1;
    IBOutlet UITextField *  zip1;
    IBOutlet UITextField *  country1;
    
    IBOutlet UIView *portraitView1;
    IBOutlet UIView *landscapView1;

    
}
-(IBAction)Submit:(id)sender;

@end
