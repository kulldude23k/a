
#import "RegistrationViewController.h"
#import "AppDelegate.h"
#import "NSString+StringValidations.h"
@interface RegistrationViewController ()

@property (nonatomic,strong) IBOutlet UIButton *mSubmitButton;
@property (nonatomic,strong) IBOutlet UIButton *mBackButton;
@property (nonatomic,strong) IBOutlet UIButton *mSigninButton;

@property (nonatomic,strong) IBOutlet UITextField *mNameTextfield;
@property (nonatomic,strong) IBOutlet UITextField *mEmailTextfield;
@property (nonatomic,strong) IBOutlet UITextField *mUsernameTextfield;
@property (nonatomic,strong) IBOutlet UITextField *mPasswordTextfield;
@property (nonatomic,strong) IBOutlet UITextField *mConfirmPasswordTextfield;
@property (nonatomic,strong) IBOutlet NSString *alertMessage;
-(IBAction)SubmitButtonAction:(id)sender;
-(IBAction)BackButtonAction:(id)sender;
-(IBAction)SigninButtonAction:(id)sender;
@end

@implementation RegistrationViewController
@synthesize mSubmitButton;
@synthesize mBackButton;
@synthesize mSigninButton;
@synthesize mNameTextfield;
@synthesize mEmailTextfield;
@synthesize mUsernameTextfield;
@synthesize mPasswordTextfield;
@synthesize mConfirmPasswordTextfield;
@synthesize alertMessage;

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
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        [self clearCurrentView];
        mNameTextfield.frame=CGRectMake(395, 281, 282, 35);
        mEmailTextfield.frame=CGRectMake(395, 332, 282, 35);
        mUsernameTextfield.frame=CGRectMake(395, 379, 282, 35);
        mPasswordTextfield.frame=CGRectMake(395, 432, 282, 35);
        mConfirmPasswordTextfield.frame=CGRectMake(395, 481, 282, 35);
        [self.view insertSubview:landscapView atIndex:0];
                
        
    }else if (toInterfaceOrientation==UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        [self clearCurrentView];
        mNameTextfield.frame=CGRectMake(286, 309, 282, 35);
        mEmailTextfield.frame=CGRectMake(286, 360, 282, 35);
        mUsernameTextfield.frame=CGRectMake(286, 407, 282, 35);
        mPasswordTextfield.frame=CGRectMake(286, 460, 282, 35);
        mConfirmPasswordTextfield.frame=CGRectMake(286, 514, 282, 35);
        
        [self.view insertSubview:portraitView atIndex:0];
        
    }
}
-(void) clearCurrentView {
    
    if (landscapView.superview) {
        
        [landscapView removeFromSuperview];
        
    } else if (portraitView.superview) {
        
        [portraitView removeFromSuperview];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    registerView_por.layer.shadowPath = [UIBezierPath bezierPathWithRect:registerView_por.bounds].CGPath;
    // loginView.layer.shadowColor = [UIColor purpleColor].CGColor;
    registerView_por.layer.shadowOffset = CGSizeMake(0, 2);
    registerView_por.layer.shadowOpacity = 1;
    registerView_por.layer.shadowRadius = 5.0;
    registerView_por.clipsToBounds = NO;
    
    registerView_lan.layer.shadowPath = [UIBezierPath bezierPathWithRect:registerView_lan.bounds].CGPath;
    // loginView.layer.shadowColor = [UIColor purpleColor].CGColor;
    registerView_lan.layer.shadowOffset = CGSizeMake(0, 2);
    registerView_lan.layer.shadowOpacity = 1;
    registerView_lan.layer.shadowRadius = 5.0;
    registerView_lan.clipsToBounds = NO;
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation  == UIInterfaceOrientationLandscapeRight) {
        [self clearCurrentView];
        mNameTextfield.frame=CGRectMake(395, 281, 282, 35);
        mEmailTextfield.frame=CGRectMake(395, 332, 282, 35);
        mUsernameTextfield.frame=CGRectMake(395, 379, 282, 35);
        mPasswordTextfield.frame=CGRectMake(395, 432, 282, 35);
        mConfirmPasswordTextfield.frame=CGRectMake(395, 481, 282, 35);
        
        [self.view insertSubview:landscapView atIndex:0];
        
    }
    else {
        mNameTextfield.frame=CGRectMake(286, 309, 282, 35);
        mEmailTextfield.frame=CGRectMake(286, 360, 282, 35);
        mUsernameTextfield.frame=CGRectMake(286, 407, 282, 35);
        mPasswordTextfield.frame=CGRectMake(286, 460, 282, 35);
        mConfirmPasswordTextfield.frame=CGRectMake(286, 514, 282, 35);
        [self clearCurrentView];
        [self.view insertSubview:portraitView atIndex:0];
        
    }
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

-(IBAction)SubmitButtonAction:(id)sender {
    NSLog(@"Submit Clicked");
    
   // [self dismissModalViewControllerAnimated:YES];
    
//    AppDelegate *delegate=(AppDelegate*) [[UIApplication sharedApplication] delegate];
//    [delegate.window.rootViewController dismissModalViewControllerAnimated:YES];
    
    NSString *trimmedStringForName = [NSString checkForEmptyStringWithTextFieldString:mNameTextfield.text];
    NSString *trimmedStringForUserName = [NSString checkForEmptyStringWithTextFieldString:mUsernameTextfield.text];
    NSString *trimmedStringForPassword = [NSString checkForEmptyStringWithTextFieldString:mPasswordTextfield.text];
    NSString *trimmedStringForconfirmPassword = [NSString checkForEmptyStringWithTextFieldString:mConfirmPasswordTextfield.text];
    NSString *trimmedStringForEmail = [NSString checkForEmptyStringWithTextFieldString:mEmailTextfield.text];
    
    if ((trimmedStringForName.length == 0) || (trimmedStringForUserName.length == 0) ||(trimmedStringForPassword.length == 0) || (trimmedStringForconfirmPassword.length == 0) ||(trimmedStringForEmail.length == 0)) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter all the details." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        return;
        
    }
    
    
    if(![NSString stringIsValidEmail:mEmailTextfield.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter valid email address." delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        
        [alert show];
        return;
        
    }
    
    if (![mPasswordTextfield.text isEqualToString:mConfirmPasswordTextfield.text]) {
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Confirm Password should match with Password" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        
        [alert show];
        return;

    }
    
    else {
        
        [[NSUserDefaults standardUserDefaults]  setObject:mUsernameTextfield.text forKey:@"userName"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Registration Successful" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        
        [alert show];

    }

}

-(IBAction)BackButtonAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)SigninButtonAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0  && [alertMessage isEqualToString:@"Registration Successfull"]) {
        
        [self dismissModalViewControllerAnimated:YES];
    }
}


@end
