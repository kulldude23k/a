//
//  Request_information.m
//  Magazine
//
//  Created by Fstech on 3/5/13.
//  Copyright (c) 2013 Fstech. All rights reserved.
//

#import "Request_information.h"
#import "NSString+StringValidations.h"
#import <QuartzCore/QuartzCore.h>
//static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
//static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
//static const CGFloat MAXIMUM_SCROLL_FRACTION = 4.0;
//static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
//static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 352;



static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 352;




@interface Request_information ()

@end

@implementation Request_information

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}











-(IBAction)Submit:(id)sender{
    
    
    
    
    
    NSLog(@"submit");
    
    
    
    
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation  == UIInterfaceOrientationLandscapeRight) {
       
        
        if(![NSString stringIsValidEmail:emailAddress.text]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Enter Valid Email Address" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            
            alert.tag = 200;
            [alert show];
            return;
            
        }
        
        else {
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
            [request setURL:[NSURL URLWithString:@"http://182.50.141.148/iphonequiz/request_product_%20info.php"]];
            
                //    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://182.50.141.148/iphonequiz/new_event.php"]];
            
            [request setHTTPMethod:@"POST"];
            
            NSString *post =[[NSString alloc] initWithFormat:@"first_name=%@&last_name=%@&medical_affilation=%@&email_address=%@&phone=%@&address=%@&address_line2=%@&city=%@&state=%@&zip_code=%@&contry=%@",firstName.text,lastName.text,medical.text,emailAddress.text,Phone.text,Address.text,AddressLine2.text,city.text,state.text,zip.text,country.text];
            
          
            
            
            
            NSLog(@"String is:%@",post);
            
                //    NSString *postlength = [NSString stringWithFormat:@"%d",post.length];
                //    [request setValue:postlength forHTTPHeaderField:@"Content-Length"];
                //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPBody:[post dataUsingEncoding:NSASCIIStringEncoding]];
            
            NSURLResponse *response;
            NSError *err;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            
            NSDictionary *strDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            
                //    NSString *strResult = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
                //    NSLog(@"Result is :%@",strResult);
            
            NSString *alertMessage;
            
            if ([[strDict valueForKey:@"Message"]isEqualToString:@"success"]) {
                
                 alertMessage = @"Request sent successfully.";
            }
            
            else {
                
                alertMessage = @"Error in sending mail";
            }
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:alertMessage delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            
        }

        
        
        
        
    }else
    {
        
        
        if(![NSString stringIsValidEmail:emailAddress1.text]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Enter Valid Email Address" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            
            alert.tag = 200;
            [alert show];
            return;
            
        }
        
        else {
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
            [request setURL:[NSURL URLWithString:@"http://182.50.141.148/iphonequiz/request_product_%20info.php"]];
            
                //    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://182.50.141.148/iphonequiz/new_event.php"]];
            
            [request setHTTPMethod:@"POST"];
            
             NSString *post =[[NSString alloc] initWithFormat:@"first_name=%@&last_name=%@&medical_affilation=%@&email_address=%@&phone=%@&address=%@&address_line2=%@&city=%@&state=%@&zip_code=%@&contry=%@",firstName1.text,lastName1.text,medical1.text,emailAddress1.text,Phone1.text,Address1.text,AddressLine21.text,city1.text,state1.text,zip1.text,country1.text];
            
            NSLog(@"String is:%@",post);
            
                //    NSString *postlength = [NSString stringWithFormat:@"%d",post.length];
                //    [request setValue:postlength forHTTPHeaderField:@"Content-Length"];
                //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPBody:[post dataUsingEncoding:NSASCIIStringEncoding]];
            
            NSURLResponse *response;
            NSError *err;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            
            NSDictionary *strDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            
                //    NSString *strResult = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
                //    NSLog(@"Result is :%@",strResult);
            
            NSString *alertMessage;
            
            if ([[strDict valueForKey:@"Message"]isEqualToString:@"success"]) {
                
                 alertMessage = @"Request sent successfully.";
            }
            
            else {
                
                alertMessage = @"Error in sending mail";
            }
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:alertMessage delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            
        }


        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    }


-(void) clearCurrentView {
    @try {
        if (landscapView.superview) {
            
            [landscapView removeFromSuperview];
            
        } else if (portraitView.superview) {
            
            [portraitView removeFromSuperview];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-clearCurrentView Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}




- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    @try {
            //        [timer_por invalidate];
            //        timer_por=nil;
            //        [timer_lan invalidate];
            //        timer_lan=nil;
        
        if (toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            
            [self clearCurrentView];
            self.view.frame=landscapView.frame;
            
            [self.view insertSubview:landscapView atIndex:0];
            
            
            
            
        }
        
        if (toInterfaceOrientation==UIInterfaceOrientationPortrait||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
            
            [self clearCurrentView];
            
            self.view.frame=portraitView.frame;
            [self.view insertSubview:portraitView atIndex:0];
            
        }
        
            //            timer_por=  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(flipAnimation_por) userInfo:nil repeats:YES];
            //            timer_lan=  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(flipAnimation_lan) userInfo:nil repeats:YES];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-willRotateToInterfaceOrientation Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}











-(void)viewWillAppear:(BOOL)animated
{
    
    
  
    
    
   
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation  == UIInterfaceOrientationLandscapeRight) {
        [self clearCurrentView];
        
        self.view.frame=landscapView.frame;
        [self.view insertSubview:landscapView atIndex:0];
    }else
    {
        [self clearCurrentView];
        
        self.view.frame=portraitView.frame;
        [self.view insertSubview:portraitView atIndex:0];
        
    }
    
    
    [emailAddress setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailAddress1 setKeyboardAppearance:UIKeyboardTypeEmailAddress];
    [Phone setKeyboardAppearance:UIKeyboardTypeNumberPad];
     [Phone1 setKeyboardAppearance:UIKeyboardTypeNumberPad];
    [zip setKeyboardAppearance:UIKeyboardTypeNumberPad];
    [zip1 setKeyboardAppearance:UIKeyboardTypeNumberPad];
    
    
    
    
    
    
}



-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
   
    
}




    //code to make keyboard upp


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
