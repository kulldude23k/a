
#import "QuizSectionViewController.h"
#import "EpworthViewController.h"
//#import "QuizViewController.h"
#import "BerlinViewController.h"
#import "Quiz.h"
#import "StopBangQuiz.h"
#import "NetworkCheck.h"
#import "DelegateClass.h"
#import "StopBangViewController.h"
#import "BerlinQuiz.h"



@interface QuizSectionViewController ()
@property (nonatomic, strong)SettingsViewController *settingView;

@end

@implementation QuizSectionViewController
@synthesize Viewcontroller=_Viewcontroller;
@synthesize hud=_hud;
@synthesize settingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Hud View

- (void)dismissHUD:(id)arg {
    @try {
        
        if ([(NSString *)arg isEqual:@"Time Out"]) {
            [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Timed Out!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        [web cancelConnection];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        self.hud = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-dismissHUD Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

#pragma mark - Connection methods

- (void)didReceiveErrorFromServer:(NSString *)error
{
    @try {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-didReceiveErrorFromServer Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

- (void)successLoading:(BOOL)success
{
    @try {
        if (success) {
            
            // [[[DelegateClass magazine].Top_story objectAtIndex:5] _image_name];
            
            // [[DelegateClass magazine] NSLog:[[[DelegateClass magazine].Top_story objectAtIndex:5] _image_name]];
            
            self.navigationController.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:self.Viewcontroller animated:YES];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-successLoading Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}
- (void)didReceiveResponseFromServer:(NSString *)responseData
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    @try {
        NSData *data = [responseData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json=[[NSDictionary alloc]init];
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"%d",[json count]);
        if ([json count]>0) {
            NSString *forView=[json objectForKey:@"view"];
                       if ([forView isEqual:@"quiz"]) {
                NSDictionary *content=[json objectForKey:@"content"];
                Quiz *quiz_content=[[DelegateClass magazine] jsonParsingForQuiz:content];
                [[DelegateClass magazine] setMg_quiz:quiz_content._quiz_details];
            }
            
            if ([forView isEqual:@"stopbang"]) {
                NSDictionary *content=[json objectForKey:@"content"];
                StopBangQuiz *quiz_content=[[DelegateClass magazine] jsonParsingForStopBangQuiz:content];
                [[DelegateClass magazine] setMg_stopbang_quiz:quiz_content._st_quiz_details];
            }
            if ([forView isEqual:@"berlin"]) {
                NSDictionary *content=[json objectForKey:@"content"];
                BerlinQuiz *quiz_content=[[DelegateClass magazine] jsonParsingForBerlinQuiz:content];
                [[DelegateClass magazine] setMg_berlin_quiz:quiz_content._category_array];
            }
           
        }
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:1.0];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-didReceiveResponseFromServer Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

- (BOOL) checkConnection
{
    @try {
        if ([[NetworkCheck checkInternetConnection] statusForConnection]) {
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-checkConnection Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

- (BOOL) createRequest:(NSString *)requestUrl
{
    @try {
        if ([self checkConnection]) {
            web =[[WebServiceCall alloc]initWithDelegate:self];
            [web setURL:requestUrl];
            [web startRequest];
            
        } else {
            return NO;
        }
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createRequest Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}
-(IBAction)stopBangQuiz:(id)sender
{
    self.Viewcontroller=Nil;
    if ([self createRequest:StopBangQuizURL]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Loading quiz...";
        _hud.mode = MBProgressHUDModeCustomView;
        [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:30.0];
        
        // QuizViewController *loVideoviewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
        StopBangViewController *stopQuizviewController = [[StopBangViewController alloc] initWithNibName:@"StopBangViewController" bundle:nil];
        
        self.Viewcontroller = stopQuizviewController;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    
}
-(IBAction)berlinQuiz:(id)sender
{
    self.Viewcontroller=Nil;
    if ([self createRequest:BerlinQuizURL]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Loading quiz...";
        _hud.mode = MBProgressHUDModeCustomView;
        [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:30.0];
        
        // QuizViewController *loVideoviewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
         BerlinViewController *berlinQuizviewController=[[BerlinViewController alloc]initWithNibName:@"BerlinViewController" bundle:[NSBundle mainBundle]];
        
        self.Viewcontroller = berlinQuizviewController;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }


    
}
-(IBAction)epworthQuiz:(id)sender
{
    @try {
        //        [timer_por invalidate];
        //        timer_por=nil;
        //        [timer_lan invalidate];
        //        timer_lan=nil;
        //    [timer_por_art invalidate];
        //    timer_por_art=nil;
        //    [timer_lan_art invalidate];
        //    timer_lan_art=nil;
        
        self.Viewcontroller=Nil;
        if ([self createRequest:QuizURL]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading quiz...";
            _hud.mode = MBProgressHUDModeCustomView;
            [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:30.0];
            
            // QuizViewController *loVideoviewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
             EpworthViewController *epworthviewController = [[EpworthViewController alloc] initWithNibName:@"EpworthViewController" bundle:nil];
            
            self.Viewcontroller = epworthviewController;
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-Quiz Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
    UIImage *buttonImage = [UIImage imageNamed:@"setting icon1.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
    // Initialize the UIBarButtonItem
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    // Set the Target and Action for aButton
    [aButton addTarget:self action:@selector(SettingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = aBarButtonItem;

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
}

- (void)SettingButtonAction:(id)sender {
    
    @try {
        if (![DelegateClass magazine]._settingsOn) {
            settingView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            // settingView.view.bounds=CGRectMake(0, 0, 320, 320);
            settingView.view.center = self.view.center;
            settingView.backgrdView.frame=self.view.frame;
            [self.view addSubview:settingView.backgrdView];
            [self.view addSubview:settingView.view];
            [[NSUserDefaults standardUserDefaults] setObject:@"Quiz" forKey:@"SettingViewAppeared"];
            [DelegateClass magazine]._settingsOn=YES;
            // [moviePlayer pause];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"ArtOfSleepingViewController -settingButtonActionInArtOfSleeping Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
