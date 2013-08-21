

#import "ViewController.h"
#import "AppDelegate.h"

#import "LoginViewController.h"
#import "LinkedInLoginViewController.h"
#import "SCProtocols.h"
#import <AddressBook/AddressBook.h>
#import "TargetConditionals.h"
#import "TopStoryViewController.h"
#import "VideoViewController.h"
#import "SettingsViewController.h"
#import "DelegateClass.h"
#import "WebServiceCall.h"
#import "NetworkCheck.h"
#import "TopStory.h"
#import "EpworthViewController.h"
    //#import "QuizViewController.h"
#import "ArtOfSleepingViewController.h"
#import "ArtOfSleeping.h"
#import "LinkedIn.h"
#import "DBTileButton.h"
#import "ImageFlipViewController.h"
#import "LinkedinViewController.h"
#import "QuizSectionViewController.h"
#import "SleepProfessionViewController.h"

#define ANIMATION_DURATION_PER_IMAGE    2.0

@interface ViewController() < UITableViewDataSource,
FBFriendPickerDelegate,
UINavigationControllerDelegate,
FBPlacePickerDelegate,
CLLocationManagerDelegate,
UIActionSheetDelegate>

@property (strong, nonatomic) FBUserSettingsViewController *settingsViewController;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage_face_portrait;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage_face_landscape;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage_twit_portrait;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage_twit_landscape;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel_portrait,*userNameLabel_landscape;
@property (strong, nonatomic) IBOutlet UIButton *announceButton;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) UIActionSheet *mealPickerActionSheet;
@property (strong, nonatomic) NSArray *mealTypes;

@property (strong, nonatomic) NSObject<FBGraphPlace> *Place;
@property (strong, nonatomic) NSString *Meal;
@property (strong, nonatomic) NSArray *Friends;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) FBCacheDescriptor *placeCacheDescriptor;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIButton *SettingButton;
@property (nonatomic, strong) SettingsViewController *settingView;


-(IBAction)SettingButtonAction:(id)sender;


@end

@implementation ViewController
@synthesize hud=_hud;
@synthesize Viewcontroller=_Viewcontroller;
@synthesize userNameLabel_portrait = _userNameLabel_portrait;
@synthesize userNameLabel_landscape = _userNameLabel_landscape;
@synthesize userProfileImage_face_portrait = _userProfileImage_face_portrait;
@synthesize userProfileImage_face_landscape = _userProfileImage_face_landscape;
@synthesize userProfileImage_twit_portrait = _userProfileImage_twit_portrait;
@synthesize userProfileImage_twit_landscape = _userProfileImage_twit_landscape;
@synthesize Place = _Place;
@synthesize Meal = _Meal;
@synthesize Friends = _Friends;
@synthesize announceButton = _announceButton;
@synthesize menuTableView = _menuTableView;
@synthesize locationManager = _locationManager;
@synthesize mealPickerActionSheet = _mealPickerActionSheet;
@synthesize activityIndicator = _activityIndicator;
@synthesize settingsViewController = _settingsViewController;
@synthesize mealTypes = _mealTypes;
@synthesize placeCacheDescriptor = _placeCacheDescriptor;
@synthesize SettingButton;
@synthesize settingView;


@synthesize    oAuthLoginView;

#pragma mark - Trying to linked in view

-(void)moveToLinkedIn {
    
    LinkedinViewController *vc = [[LinkedinViewController alloc]initWithNibName:@"LinkedinViewController" bundle:nil];
    
    UIViewController *topViewController = [self.navigationController topViewController];
    [topViewController presentModalViewController:vc animated:NO];
    
    [self presentModalViewController:vc animated:YES];
}

#pragma mark logout option

-(void)logoutButtonWasPressed:(id)sender {
    @try {
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-logoutButtonWasPressed Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}
-(void) updateProfileForLinkedIn:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
        // We're going to do these calls serially just for easy code reading.
        // They can be done asynchronously
        // Get the profile, then the network updates
    [[LinkedIn linked] profileApiCall];
    
}


#pragma mark - To show user details

    // to get user details
- (void)populateUserDetails {
    @try {
        if (FBSession.activeSession.isOpen) {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                 if (!error) {
                     [DelegateClass magazine]._loggedThrough=@"Facebook";
                     NSString *username=[NSString stringWithFormat:@"Hello, %@",user.name];
                     self.userNameLabel_landscape.text = username;
                     self.userNameLabel_portrait.text = username;
                     [DelegateClass magazine]._userName=username;
                     [[NSUserDefaults standardUserDefaults]  setObject:username forKey:@"userName"];
                     self.userProfileImage_face_landscape.profileID = [user objectForKey:@"id"];
                     self.userProfileImage_face_portrait.profileID = [user objectForKey:@"id"];
                     
                     [DelegateClass magazine]._profImage=[user objectForKey:@"id"];
                     NSLog(@"%@",[DelegateClass magazine]._profImage);
                     self.userProfileImage_face_landscape.hidden=NO;
                     self.userProfileImage_face_portrait.hidden=NO;
                 }
             }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-populateUserDetails Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

- (void)sessionStateChanged:(NSNotification*)notification {
    @try {
            // A more complex app might check the state to see what the appropriate course of
            // action is, but our needs are simple, so just make sure our idea of the session is
            // up to date and repopulate the user's name and picture (which will fail if the session
            // has become invalid).
            // [self populateUserDetails];
        [self performSelectorOnMainThread:@selector(populateUserDetails) withObject:nil waitUntilDone:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-sessionStateChanged Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}
- (void)UpdateUserName {
    @try {
            //[self createFlipAnnimationTopStory];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"usernameUpdation" object:nil];
        self.userNameLabel_portrait.text = @"";
        self.userNameLabel_landscape.text = @"";
        
        self.userNameLabel_landscape.text =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"];
        self.userNameLabel_portrait.text =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"];
            //NSLog(@"userName Notification call= %@", self.userNameLabel.text);
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-UpdateUserName Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

#pragma mark -  Item From FlipView

-(void)ArtOfSleeping:(id)sender
{
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
            //    [timer_por_art invalidate];
            //    timer_por_art=nil;
            //    [timer_lan_art invalidate];
            //    timer_lan_art=nil;
        [self ArtOfSleepingButtonAction:sender];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-ArtOfSleeping Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

-(void)stopAnimation
{
    
    [video_imageView_port stopAnimatingWithFade];
    
    [story_imageView_port stopAnimatingWithFade];
    
    
    [event_imageView_port stopAnimatingWithFade];
    
    
}

-(void)TopStory:(id)sender
{
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
        
        [self TopStoryButtonAction:sender];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-TopStory Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

-(void)LinkedIn:(id)sender
{
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
            //    [timer_por_art invalidate];
            //    timer_por_art=nil;
            //    [timer_lan_art invalidate];
            //    timer_lan_art=nil;
        [self LinkedinButtonAction:sender];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-Quiz Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

-(void)Video:(id)sender
{
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
            //    [timer_por_art invalidate];
            //    timer_por_art=nil;
            //    [timer_lan_art invalidate];
            //    timer_lan_art=nil;
        [self VideoButtonAction:sender];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-Video Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

-(void)Event:(id)sender {
    
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
            //    [timer_por_art invalidate];
            //    timer_por_art=nil;
            //    [timer_lan_art invalidate];
            //    timer_lan_art=nil;
        [self eventButtonTapped:sender];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-Video Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
}



#pragma mark - Flip View Methods

-(void)createFlipAnnimationReports
{
    @try {
        NSArray *rep=[[NSArray alloc]initWithObjects:@"tech report.png",@"image3.jpg",@"image4.jpg",@"image5.jpg",@"image6.jpg", nil];
        
        
        image_fli_por_rep=[[ImageFlipViewController alloc]initWithDelegate:self withItems:rep forButton:@"Reports" withDirection:@"Upward"];
        image_fli_lan_rep=[[ImageFlipViewController alloc]initWithDelegate:self withItems:rep forButton:@"Reports" withDirection:@"Upward"];
        rep_por=[image_fli_por_rep createScrollViewForButton:image_fli_por_rep.buttonName withItems:image_fli_por_rep.btnArray forScrollView:rep_por withFrame:rep_por.frame];
        rep_lan=[image_fli_lan_rep createScrollViewForButton:image_fli_lan_rep.buttonName withItems:image_fli_lan_rep.btnArray forScrollView:rep_lan withFrame:rep_lan.frame];
        
        
        
        [rep_vie_por addSubview:rep_por];
        [rep_vie_lan addSubview:rep_lan];
        [portraitView addSubview:rep_vie_por];
        [landscapView addSubview:rep_vie_lan];
        
            //timer_por_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_por_top) userInfo:nil repeats:YES];
            //timer_lan_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_lan_top) userInfo:nil repeats:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createFlipAnnimationReports Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}
-(IBAction)eventButtonTapped:(id)sender {
    
    EventsViewController *vc = [[EventsViewController alloc]initWithNibName:@"EventsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createFlipAnnimationEvents
{
    @try {
        NSArray *eve=[[NSArray alloc]initWithObjects:@"1st-01.jpg",@"2nd-01.jpg",@"SleepEvent-01.jpg",@"3rd-01.jpg",@"4th-01.jpg", nil];
        
        
        image_fli_por_eve=[[ImageFlipViewController alloc]initWithDelegate:self withItems:eve forButton:@"Events" withDirection:@"Upward"];
        image_fli_lan_eve=[[ImageFlipViewController alloc]initWithDelegate:self withItems:eve forButton:@"Events" withDirection:@"Upward"];
        eve_por=[image_fli_por_eve createScrollViewForButton:image_fli_por_eve.buttonName withItems:image_fli_por_eve.btnArray forScrollView:eve_por withFrame:eve_por.frame];
        eve_lan=[image_fli_lan_eve createScrollViewForButton:image_fli_lan_eve.buttonName withItems:image_fli_lan_eve.btnArray forScrollView:eve_lan withFrame:eve_lan.frame];
        
        
        
        
        
        
        
        
        
            //[eve_vie_por addSubview:eve_por];
            // [eve_vie_lan addSubview:eve_lan];
            //[portraitView addSubview:eve_vie_por];
            //[landscapView addSubview:eve_vie_lan];
        
            //timer_por_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_por_top) userInfo:nil repeats:YES];
            //timer_lan_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_lan_top) userInfo:nil repeats:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createFlipAnnimationEvents Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}
-(void)createFlipAnnimationLinkedIn
{
    @try {
        NSArray *lin=[[NSArray alloc]initWithObjects:@"image6.jpg",@"image3.jpg",@"image4.jpg",@"image5.jpg",@"slink.png", nil];
        
        
        image_fli_por_lin=[[ImageFlipViewController alloc]initWithDelegate:self withItems:lin forButton:@"LinkedIn" withDirection:@"Downward"];
        image_fli_lan_lin=[[ImageFlipViewController alloc]initWithDelegate:self withItems:lin forButton:@"LinkedIn" withDirection:@"Downward"];
        lin_por=[image_fli_por_lin createScrollViewForButton:image_fli_por_lin.buttonName withItems:image_fli_por_lin.btnArray forScrollView:lin_por withFrame:lin_por.frame];
        lin_lan=[image_fli_lan_lin createScrollViewForButton:image_fli_lan_lin.buttonName withItems:image_fli_lan_lin.btnArray forScrollView:lin_lan withFrame:lin_lan.frame];
        
        
        
        
        
        
        
        
        
        [lin_vie_por addSubview:lin_por];
        [lin_vie_lan addSubview:lin_lan];
        [portraitView addSubview:lin_vie_por];
        [landscapView addSubview:lin_vie_lan];
        
            //timer_por_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_por_top) userInfo:nil repeats:YES];
            //timer_lan_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_lan_top) userInfo:nil repeats:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createFlipAnnimationLinkedIn Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

-(void)createFlipAnnimationVideos
{
    @try {
        NSArray *vid=[[NSArray alloc]initWithObjects:@"Video 1-01.jpg",@"Video 2-01.jpg",@"Video 3-01.jpg", Nil];
        
        
        image_fli_por_vid=[[ImageFlipViewController alloc]initWithDelegate:self withItems:vid forButton:@"Videos" withDirection:@"Downward"];
            // image_fli_lan_vid=[[ImageFlipViewController alloc]initWithDelegate:self withItems:vid forButton:@"Videos" withDirection:@"Downward"];
        vid_por=[image_fli_por_vid createScrollViewForButton:image_fli_por_vid.buttonName withItems:image_fli_por_vid.btnArray forScrollView:vid_por withFrame:vid_por.frame];
            // vid_lan=[image_fli_lan_vid createScrollViewForButton:image_fli_lan_vid.buttonName withItems:image_fli_lan_vid.btnArray forScrollView:vid_lan withFrame:vid_lan.frame];
        
        
        
        
        
        
        
        
        
            //[vid_vie_por addSubview:vid_por];
            // [vid_vie_lan addSubview:vid_lan];
            // [portraitView addSubview:vid_vie_por];
            // [landscapView addSubview:vid_vie_lan];
        
            //timer_por_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_por_top) userInfo:nil repeats:YES];
            //timer_lan_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_lan_top) userInfo:nil repeats:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createFlipAnnimationVideos Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}


-(void)createFlipAnnimationSleepQuizes
{
    @try {
        NSArray *qui=[[NSArray alloc]initWithObjects:@"Quizzer image.png",@"image3.jpg",@"image4.jpg",@"image5.jpg",@"image6.jpg", nil];
        
        
        image_fli_por_qui=[[ImageFlipViewController alloc]initWithDelegate:self withItems:qui forButton:@"SleepQuizes" withDirection:@"Upward"];
        image_fli_lan_qui=[[ImageFlipViewController alloc]initWithDelegate:self withItems:qui forButton:@"SleepQuizes" withDirection:@"Upward"];
        qui_por=[image_fli_por_qui createScrollViewForButton:image_fli_por_qui.buttonName withItems:image_fli_por_qui.btnArray forScrollView:qui_por withFrame:qui_por.frame];
        qui_lan=[image_fli_lan_qui createScrollViewForButton:image_fli_lan_qui.buttonName withItems:image_fli_lan_qui.btnArray forScrollView:qui_lan withFrame:qui_lan.frame];
        
        
        
        
        
        
        
        
        
        [qui_vie_por addSubview:qui_por];
        [qui_vie_lan addSubview:qui_lan];
        [portraitView addSubview:qui_vie_por];
        [landscapView addSubview:qui_vie_lan];
        
            //timer_por_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_por_top) userInfo:nil repeats:YES];
            //timer_lan_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_lan_top) userInfo:nil repeats:YES];
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createFlipAnnimationSleepQuizes Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

-(void)createFlipAnnimationArtOfSleeping
{
    @try {
        NSArray *art=[[NSArray alloc]initWithObjects:@"image6.jpg",@"image3.jpg",@"image4.jpg",@"image5.jpg",@"ssleep.png", nil];
        
        
        image_fli_por_art=[[ImageFlipViewController alloc]initWithDelegate:self withItems:art forButton:@"ArtOfSleeping" withDirection:@"Downward"];
        image_fli_lan_art=[[ImageFlipViewController alloc]initWithDelegate:self withItems:art forButton:@"ArtOfSleeping" withDirection:@"Downward"];
        
        art_por=[image_fli_por_art createScrollViewForButton:image_fli_por_art.buttonName withItems:image_fli_por_art.btnArray forScrollView:art_por withFrame:art_por.frame];
        art_lan=[image_fli_lan_art createScrollViewForButton:image_fli_lan_art.buttonName withItems:image_fli_lan_art.btnArray forScrollView:art_lan withFrame:art_lan.frame];
        
        
        [art_vie_por addSubview:art_por];
        [art_vie_lan addSubview:art_lan];
        [portraitView addSubview:art_vie_por];
        [landscapView addSubview:art_vie_lan];
        
            //timer_por_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_por_top) userInfo:nil repeats:YES];
            //timer_lan_top=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flipAnimation_lan_top) userInfo:nil repeats:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createFlipAnnimationArtOfSleeping Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

-(void)createFlipAnnimationTopStory
{
    @try {
            //        [top_str_por removeFromSuperview];
        
        NSArray *top=[[NSArray alloc]initWithObjects:@"Experience.png",@"Introducing-A-Novel.png",@"The-Battle.png",@"The Video Advantage1-01.jpg",@"Web_Based_HST.jpg", Nil];
        image_fli_por_top=[[ImageFlipViewController alloc]initWithDelegate:self withItems:top forButton:@"TopStory" withDirection:@"Upward"];
            // image_fli_lan_top=[[ImageFlipViewController alloc]initWithDelegate:self withItems:top forButton:@"TopStory" withDirection:@"Upward"];
        top_str_por=[image_fli_por_top createScrollViewForButton:image_fli_por_top.buttonName withItems:image_fli_por_top.btnArray forScrollView:top_str_por withFrame:top_str_por.frame];
            // top_str_lan=[image_fli_lan_top createScrollViewForButton:image_fli_lan_top.buttonName withItems:image_fli_lan_top.btnArray forScrollView:top_str_lan withFrame:top_str_lan.frame];
        
        
            //[top_str_vie_por addSubview:top_str_por];
        
            //[top_str_vie_por addSubview:top_str_por];
            // [top_str_vie_lan addSubview:top_str_lan];
        
        
            //[self.view addSubview:top_str_vie_por];
            //[landscapView addSubview:top_str_vie_lan];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createFlipAnnimationTopStory Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}
-(void)createFlipAnnimation
{
    @try {
        
        dispatch_queue_t TopStory = dispatch_queue_create("TopStory", NULL);
        dispatch_queue_t ArtOfSleeping = dispatch_queue_create("ArtOfSleeping", NULL);
        dispatch_queue_t Quizes = dispatch_queue_create("Quizes", NULL);
        dispatch_queue_t Videos = dispatch_queue_create("Videos", NULL);
        dispatch_queue_t Events = dispatch_queue_create("Events", NULL);
        dispatch_queue_t LinkedIn = dispatch_queue_create("LinkedIn", NULL);
        dispatch_queue_t Report = dispatch_queue_create("Report", NULL);
        
            // Use another thread to avoid blocking main thread
        
        
        dispatch_async(TopStory,^{
            
                //[self createFlipAnnimationTopStory];
            dispatch_async(dispatch_get_main_queue(),^{
                UIImageView *title_back=[[UIImageView alloc]initWithFrame:CGRectMake(top_str_por.frame.origin.x, top_str_por.frame.origin.y+235, top_str_por.bounds.size.width, 44)];
                title_back.image=[UIImage imageNamed:@"box_tr.png"];
                UILabel *title_lab=[[UILabel alloc]initWithFrame:CGRectInset(title_back.frame, 10, 10)];
                title_lab.text=@"TOP STORY";
                title_lab.backgroundColor=[UIColor clearColor];
                title_lab.textColor=[UIColor whiteColor];
                title_lab.textAlignment=UITextAlignmentLeft;
                title_lab.font=[UIFont boldSystemFontOfSize:26.0];
                
                    //[top_str_vie_por addSubview:title_back];
                    //[top_str_vie_por addSubview:title_lab];
            });
            
            dispatch_async(ArtOfSleeping,^{
                    //[self createFlipAnnimationArtOfSleeping];
                
                dispatch_async(Quizes,^{
                        //[self createFlipAnnimationSleepQuizes];
                    
                    dispatch_async(Videos,^{
                            //[self createFlipAnnimationVideos];
                        dispatch_async(dispatch_get_main_queue(),^{
                            UIImageView *title_back=[[UIImageView alloc]initWithFrame:CGRectMake(vid_por.frame.origin.x, vid_por.frame.origin.y+132, vid_por.bounds.size.width, 44)];
                            title_back.image=[UIImage imageNamed:@"box_tr.png"];
                            UILabel *title_lab=[[UILabel alloc]initWithFrame:CGRectInset(title_back.frame, 10, 10)];
                            title_lab.text=@"VIDEOS";
                            title_lab.backgroundColor=[UIColor clearColor];
                            title_lab.textColor=[UIColor whiteColor];
                            title_lab.textAlignment=UITextAlignmentLeft;
                            title_lab.font=[UIFont boldSystemFontOfSize:26.0];
                            
                                //[vid_vie_por addSubview:title_back];
                                //[vid_vie_por addSubview:title_lab];
                        });
                        
                        dispatch_async(Events,^{
                                //[self createFlipAnnimationEvents];
                            dispatch_async(dispatch_get_main_queue(),^{
                                UIImageView *title_back=[[UIImageView alloc]initWithFrame:CGRectMake(359,325+132,160, 44)];
                                title_back.image=[UIImage imageNamed:@"box_tr.png"];
                                UILabel *title_lab=[[UILabel alloc]initWithFrame:CGRectInset(title_back.frame, 10, 10)];
                                title_lab.text=@"EVENTS";
                                title_lab.backgroundColor=[UIColor clearColor];
                                title_lab.textColor=[UIColor whiteColor];
                                title_lab.textAlignment=UITextAlignmentLeft;
                                title_lab.font=[UIFont boldSystemFontOfSize:26.0];
                                
                                    //[landscapView addSubview:title_back];
                                    //[landscapView addSubview:title_lab];
                            });
                            
                            dispatch_async(LinkedIn,^{
                                    //[self createFlipAnnimationLinkedIn];
                                
                                dispatch_async(Report,^{
                                        //[self createFlipAnnimationReports];
                                    
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        timer_por=  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(flipAnimation_por) userInfo:nil repeats:YES];
                                        timer_lan=  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(flipAnimation_lan) userInfo:nil repeats:YES];
                                        
                                        
                                    });
                                    
                                });
                                
                            });
                        });
                    });
                });
            });
            
            
            
            
            
            
            
        });
        
            //        dispatch_queue_t TopStory = dispatch_queue_create("TopStory", NULL);
            //
            //
            //        // Use another thread to avoid blocking main thread
            //
            //        dispatch_async(TopStory,^{
            //
            //            [self createFlipAnnimationTopStory];
            //
            //
            //
            //        });
            //        dispatch_async(dispatch_get_main_queue(),^{
            //            timer_por=  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(flipAnimation_por) userInfo:nil repeats:YES];
            //            timer_lan=  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(flipAnimation_lan) userInfo:nil repeats:YES];
            //
            //        });
        
            // [NSThread detachNewThreadSelector:@selector(createFlipAnnimationArtOfSleeping) toTarget:self withObject:nil];
        
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-createFlipAnnimation Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
    
}
-(void)flipAnimation_por
{
    @try {
            //    dispatch_queue_t changeImage_art_por = dispatch_queue_create("changeImage_art_por", NULL);
            //    dispatch_queue_t changeImage_top_str_por = dispatch_queue_create("changeImage_top_str_por", NULL);
            //    dispatch_queue_t changeImage_qui_por = dispatch_queue_create("changeImage_qui_por", NULL);
            //    dispatch_queue_t changeImage_vid_por = dispatch_queue_create("changeImage_vid_por", NULL);
            //
            //    // Use another thread to avoid blocking main thread
            //
            //    dispatch_async(changeImage_art_por,^{
            //
            //       [image_fli_por_art changeImageForScrollView:art_por];
            //
            //
            //    });
            //    dispatch_async(changeImage_qui_por,^{
            //        [image_fli_por_qui changeImageForScrollView:qui_por];
            //
            //    });
            //    dispatch_async(changeImage_vid_por,^{
            //         [image_fli_por_vid changeImageForScrollView:vid_por];
            //    });
            //
            //    dispatch_async(changeImage_top_str_por,^{
            //       [image_fli_por_top changeImageForScrollView:top_str_por];
            //
            //    });
        
        
        [image_fli_por_art changeImageForScrollView:art_por];
        [image_fli_por_top changeImageForScrollView:top_str_por];
        [image_fli_por_qui changeImageForScrollView:qui_por];
        [image_fli_por_vid changeImageForScrollView:vid_por];
        [image_fli_por_eve changeImageForScrollView:eve_por];
        [image_fli_por_lin changeImageForScrollView:lin_por];
        [image_fli_por_rep changeImageForScrollView:rep_por];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-flipAnimation_por Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}
-(void)flipAnimation_lan
{
    @try {
            //    dispatch_queue_t changeImage_art_lan = dispatch_queue_create("changeImage_art_lan", NULL);
            //    dispatch_queue_t changeImage_top_str_lan = dispatch_queue_create("changeImage_top_str_lan", NULL);
            //    dispatch_queue_t changeImage_qui_lan = dispatch_queue_create("changeImage_qui_lan", NULL);
            //    dispatch_queue_t changeImage_vid_lan = dispatch_queue_create("changeImage_vid_lan", NULL);
            //
            //    // Use another thread to avoid blocking main thread
            //
            //    dispatch_async(changeImage_art_lan,^{
            //
            //        [image_fli_lan_art changeImageForScrollView:art_lan];
            //        dispatch_async(changeImage_top_str_lan,^{
            //            [image_fli_lan_top changeImageForScrollView:art_lan];
            //            dispatch_async(changeImage_qui_lan,^{
            //                [image_fli_lan_qui changeImageForScrollView:qui_lan];
            //                dispatch_async(changeImage_vid_lan,^{
            //                    [image_fli_lan_qui changeImageForScrollView:vid_lan];
            //                });
            //            });
            //        });
            //
            //
            //
            //
            //
            //
            //
            //    });
        
        
        
        [image_fli_lan_art changeImageForScrollView:art_lan];
        [image_fli_lan_top changeImageForScrollView:top_str_lan];
        [image_fli_lan_qui changeImageForScrollView:qui_lan];
        [image_fli_lan_vid changeImageForScrollView:vid_lan];
        [image_fli_lan_eve changeImageForScrollView:eve_lan];
        [image_fli_lan_lin changeImageForScrollView:lin_lan];
        [image_fli_lan_rep changeImageForScrollView:rep_lan];
        
        
            //    [image_fli_por_art changeImageForScrollView:art_por];
            //    [image_fli_por_top changeImageForScrollView:top_str_por];
            //    [image_fli_por_qui changeImageForScrollView:qui_por];
            //    [image_fli_por_vid changeImageForScrollView:vid_por];
        
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-flipAnimation_lan Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}


#pragma mark - View Life Cycles

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
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
-(void)viewDidDisappear:(BOOL)animated
{
    @try {
            //    [timer_por invalidate];
            //    timer_por=nil;
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
        
        
            //    [timer_por_art invalidate];
            //    timer_por_art=nil;
            //    [timer_lan_art invalidate];
            //    timer_lan_art=nil;
        [super viewDidDisappear:animated];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-viewDidDisappear Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentImageForTopStory = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProfileForLinkedIn:)
                                                 name:@"UpdateProfileForLinkedIn"
                                               object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:SCSessionStateChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateUserName)
                                                 name:@"usernameUpdation"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateProfile)
                                                 name:@"UpdateProfileImageLinkedIn"
                                               object:nil];
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"setting icon1.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
        // Initialize the UIBarButtonItem
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
        // Set the Target and Action for aButton
    [aButton addTarget:self action:@selector(SettingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = aBarButtonItem;
    
}
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    @try {
        
        if ([self createRequest:TopStoryImagesURL]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading Images...";
            _hud.mode = MBProgressHUDModeCustomView;
            [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:90.0];
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-TopStoryButtonAction Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
    /* self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
     initWithTitle:@"Settings"
     style:UIBarButtonItemStyleBordered
     target:self
     action:@selector(settingsButtonWasPressed:)]; */
    
        // Do any additional setup after loading the view, typically from a nib.
}
-(void)UpdateProfile
{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateProfileImageLinkedIn" object:nil];
        self.userNameLabel_landscape.text = [DelegateClass magazine]._userName;
        self.userNameLabel_portrait.text = [DelegateClass magazine]._userName;
        self.userProfileImage_twit_landscape.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._linkedinUrl]]];
        self.userProfileImage_twit_landscape.hidden=NO;
        self.userProfileImage_twit_portrait.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._linkedinUrl]]];
        self.userProfileImage_twit_portrait.hidden=NO;
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-UpdateProfile Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    imageArray=[[NSMutableArray alloc] init];
    
    [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"1st-01.jpg"]]];
    [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"2nd-01.jpg"]]];
    [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SleepEvent-01.jpg"]]];
    [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"3rd-01.jpg"]]];
    [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"4th-01.jpg"]]];
    
    
    /*   topstory_imageArray=[[NSMutableArray alloc] init];
     [topstory_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Experience.png"]]];
     [topstory_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Introducing-A-Novel.png"]]];
     [topstory_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"The-Battle.png"]]];
     [topstory_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"The Video Advantage1-01.jpg"]]];
     [topstory_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"web-based.png"]]];
     */
    video_imageArray=[[NSMutableArray alloc] init];
    
    [video_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Video 1-01.jpg"]]];
    [video_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Video 2-01.jpg"]]];
    [video_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Video 3-01.jpg"]]];
    [video_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Video 1-01.jpg"]]];
    [video_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Video 2-01.jpg"]]];
    
        ///fading
    event_imageView_port.animationImages   = imageArray;
    event_imageView_port.animationDuration = [imageArray count] * ANIMATION_DURATION_PER_IMAGE;
    
    [event_imageView_port startAnimatingWithFade];
        /////
        ///fading topstory_imageArray
    NSLog(@"count=%d",topstory_imageArray.count);
    story_imageView_port.animationImages   = topstory_imageArray;
    story_imageView_port.animationDuration = [topstory_imageArray count] * ANIMATION_DURATION_PER_IMAGE;
    
    [story_imageView_port startAnimatingWithFade];
        /////
    
        ///fading video_imageView_port
    video_imageView_port.animationImages   = video_imageArray;
    video_imageView_port.animationDuration = [video_imageArray count] * ANIMATION_DURATION_PER_IMAGE;
    
    [video_imageView_port startAnimatingWithFade];
        /////
    
    
    @try {
        [super viewDidAppear:animated];
        [DelegateClass magazine]._settingsOn=NO;
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.hidesWhenStopped = YES;
        [self.view addSubview:self.activityIndicator];
        
        
        
        [[DelegateClass magazine].moviePlayer stop];
        self.userNameLabel_landscape.text =  @"";
        self.userNameLabel_portrait.text =  @"";
        self.userNameLabel_landscape.text =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"];
        self.userNameLabel_portrait.text =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"];
        SettingButton.hidden = NO;
        self.userProfileImage_face_landscape.hidden=YES;
        self.userProfileImage_face_portrait.hidden=YES;
        [super viewWillAppear:animated];
        
        if ([[DelegateClass magazine]._loggedThrough isEqual:@"Facebook"]) {
            if (FBSession.activeSession.isOpen) {
                self.userProfileImage_twit_landscape.hidden=YES;
                self.userProfileImage_twit_landscape.image=Nil;
                self.userProfileImage_twit_portrait.hidden=YES;
                self.userProfileImage_twit_portrait.image=Nil;
                    // [self populateUserDetails];
                [self performSelectorOnMainThread:@selector(populateUserDetails) withObject:nil waitUntilDone:YES];
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SuccessfulLogin"];
                self.userProfileImage_face_landscape.hidden=NO;
                self.userProfileImage_face_portrait.hidden=NO;
            }
                // [self createFlipAnnimationTopStory];
            
        }else if ([[DelegateClass magazine]._loggedThrough isEqual:@"Twitter"]) {
            self.userProfileImage_face_portrait.hidden=YES;
            self.userProfileImage_face_landscape.hidden=YES;
            self.userProfileImage_face_landscape.profileID=Nil;
            self.userProfileImage_face_portrait.profileID=Nil;
            self.userProfileImage_twit_landscape.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._profImage]]];
            self.userProfileImage_twit_landscape.hidden=NO;
            self.userProfileImage_twit_portrait.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._profImage]]];
            self.userProfileImage_twit_portrait.hidden=NO;
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SuccessfulLogin"];
            
        }else if ([[DelegateClass magazine]._loggedThrough isEqual:@"LinkedIn"]) {
            self.userProfileImage_face_portrait.hidden=YES;
            self.userProfileImage_face_landscape.hidden=YES;
            self.userProfileImage_face_landscape.profileID=Nil;
            self.userProfileImage_face_portrait.profileID=Nil;
            self.userProfileImage_twit_landscape.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._linkedinUrl]]];
            self.userProfileImage_twit_landscape.hidden=NO;
            self.userProfileImage_twit_portrait.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._linkedinUrl]]];
            self.userProfileImage_twit_portrait.hidden=NO;
            
            
        }else if ([[DelegateClass magazine]._loggedThrough isEqual:@"Application"])
        {
                // [self createFlipAnnimation];
            
            
        }
        
        [DelegateClass magazine]._settingsOn = NO;
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation  == UIInterfaceOrientationLandscapeRight) {
            [self clearCurrentView];
            homeView.frame=CGRectMake(40, 25, homeView.bounds.size.width,homeView.bounds.size.height);
            [landscapView addSubview:homeView];
            settingView.backgrdView.frame=landscapView.frame;
            self.view.frame=landscapView.frame;
            [self.view insertSubview:landscapView atIndex:0];
                //top_str_vie_por.frame=CGRectMake(24, 40, top_str_vie_por.bounds.size.width, top_str_vie_por.bounds.size.height);
            top_str_por.frame=CGRectMake(0, 0, top_str_por.bounds.size.width, top_str_por.bounds.size.height);
            
                //eve_vie_por.frame=CGRectMake(359, 324, eve_vie_por.bounds.size.width, eve_vie_por.bounds.size.height);
            eve_por.frame=CGRectMake(0, 0, eve_por.bounds.size.width, eve_por.bounds.size.height);
            
                //vid_vie_por.frame=CGRectMake(527, 324, vid_vie_por.bounds.size.width, vid_vie_por.bounds.size.height);
            vid_por.frame=CGRectMake(0, 0, vid_por.bounds.size.width, vid_por.bounds.size.height);
            
        }
        else {
            [self clearCurrentView];
            homeView.frame=CGRectMake(52, 171, homeView.bounds.size.width,homeView.bounds.size.height);
            [portraitView addSubview:homeView];
            self.view.frame=portraitView.frame;
            settingView.backgrdView.frame=portraitView.frame;
            
            [self.view insertSubview:portraitView atIndex:0];
                //top_str_vie_por.frame=CGRectMake(52, 171, top_str_vie_por.bounds.size.width, top_str_vie_por.bounds.size.height);
            top_str_por.frame=CGRectMake(0, 0, top_str_por.bounds.size.width, top_str_por.bounds.size.height);
            
                //eve_vie_por.frame=CGRectMake(387, 457, eve_vie_por.bounds.size.width, eve_vie_por.bounds.size.height);
            eve_por.frame=CGRectMake(0, 0, eve_por.bounds.size.width, eve_por.bounds.size.height);
            
                //vid_vie_por.frame=CGRectMake(555, 457, vid_vie_por.bounds.size.width, vid_vie_por.bounds.size.height);
            vid_por.frame=CGRectMake(0, 0, vid_por.bounds.size.width, vid_por.bounds.size.height);
        }
        
        
        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"SuccessfulLogin"]) {
            
            
            
            [NSThread detachNewThreadSelector:@selector(createFlipAnnimation) toTarget:self withObject:Nil];
                //[self createFlipAnnimation];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-viewWillAppear Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}
/*
 -(void)viewWillAppear:(BOOL)animated
 {
 @try {
 
 [DelegateClass magazine]._settingsOn=NO;
 self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 self.activityIndicator.hidesWhenStopped = YES;
 [self.view addSubview:self.activityIndicator];
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(updateProfileForLinkedIn:)
 name:@"UpdateProfileForLinkedIn"
 object:Nil];
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(sessionStateChanged:)
 name:SCSessionStateChangedNotification
 object:nil];
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(UpdateUserName)
 name:@"usernameUpdation"
 object:nil];
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(UpdateProfile)
 name:@"UpdateProfileImageLinkedIn"
 object:nil];
 
 
 [[DelegateClass magazine].moviePlayer stop];
 self.userNameLabel_landscape.text =  @"";
 self.userNameLabel_portrait.text =  @"";
 self.userNameLabel_landscape.text =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"];
 self.userNameLabel_portrait.text =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"];
 SettingButton.hidden = NO;
 self.userProfileImage_face_landscape.hidden=YES;
 self.userProfileImage_face_portrait.hidden=YES;
 [super viewWillAppear:animated];
 
 if ([[DelegateClass magazine]._loggedThrough isEqual:@"Facebook"]) {
 if (FBSession.activeSession.isOpen) {
 self.userProfileImage_twit_landscape.hidden=YES;
 self.userProfileImage_twit_landscape.image=Nil;
 self.userProfileImage_twit_portrait.hidden=YES;
 self.userProfileImage_twit_portrait.image=Nil;
 // [self populateUserDetails];
 [self performSelectorOnMainThread:@selector(populateUserDetails) withObject:nil waitUntilDone:YES];
 [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SuccessfulLogin"];
 self.userProfileImage_face_landscape.hidden=NO;
 self.userProfileImage_face_portrait.hidden=NO;
 }
 // [self createFlipAnnimationTopStory];
 
 }else if ([[DelegateClass magazine]._loggedThrough isEqual:@"Twitter"]) {
 self.userProfileImage_face_portrait.hidden=YES;
 self.userProfileImage_face_landscape.hidden=YES;
 self.userProfileImage_face_landscape.profileID=Nil;
 self.userProfileImage_face_portrait.profileID=Nil;
 self.userProfileImage_twit_landscape.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._profImage]]];
 self.userProfileImage_twit_landscape.hidden=NO;
 self.userProfileImage_twit_portrait.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._profImage]]];
 self.userProfileImage_twit_portrait.hidden=NO;
 [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SuccessfulLogin"];
 
 }else if ([[DelegateClass magazine]._loggedThrough isEqual:@"LinkedIn"]) {
 self.userProfileImage_face_portrait.hidden=YES;
 self.userProfileImage_face_landscape.hidden=YES;
 self.userProfileImage_face_landscape.profileID=Nil;
 self.userProfileImage_face_portrait.profileID=Nil;
 self.userProfileImage_twit_landscape.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._linkedinUrl]]];
 self.userProfileImage_twit_landscape.hidden=NO;
 self.userProfileImage_twit_portrait.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._linkedinUrl]]];
 self.userProfileImage_twit_portrait.hidden=NO;
 
 
 }else if ([[DelegateClass magazine]._loggedThrough isEqual:@"Application"])
 {
 // [self createFlipAnnimation];
 
 
 }
 
 [DelegateClass magazine]._settingsOn = NO;
 if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation  == UIInterfaceOrientationLandscapeRight) {
 [self clearCurrentView];
 settingView.backgrdView.frame=landscapView.frame;
 self.view.frame=landscapView.frame;
 [self.view insertSubview:landscapView atIndex:0];
 
 }
 else {
 [self clearCurrentView];
 self.view.frame=portraitView.frame;
 settingView.backgrdView.frame=portraitView.frame;
 
 [self.view insertSubview:portraitView atIndex:0];
 
 }
 
 
 if ([[NSUserDefaults standardUserDefaults]integerForKey:@"SuccessfulLogin"]) {
 
 
 
 [self createFlipAnnimationTopStory];
 
 }
 }
 @catch (NSException *exception) {
 NSLog(@"ViewController-viewWillAppear Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
 }
 
 
 }*/
    //-(void)flipAnimation_por_top
    //{
    //    [image_fli_por_top changeImageForScrollView:top_str_por];
    //    //[image_fli_por_art changeImageForScrollView:art_por];
    //
    //
    //
    //}
    //-(void)flipAnimation_lan_top
    //{
    //    [image_fli_lan_top changeImageForScrollView:top_str_lan];
    //   // [image_fli_por_art changeImageForScrollView:art_por];
    //
    //
    //}
- (void)viewDidUnload {
    
    @try {
        [super viewDidUnload];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-viewDidUnload Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
        // Release any retained subviews of the main view.
    
}

#pragma mark - Interface Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    @try {
            //        [timer_por invalidate];
            //        timer_por=nil;
            //        [timer_lan invalidate];
            //        timer_lan=nil;
        
        if (toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            
            [self clearCurrentView];
            homeView.frame=CGRectMake(40, 25, homeView.bounds.size.width,homeView.bounds.size.height);
            [landscapView addSubview:homeView];
            self.view.frame=landscapView.frame;
            settingView.backgrdView.frame=landscapView.frame;
            [self.view insertSubview:landscapView atIndex:0];
            settingView.view.center=self.view.center;
                //settingView.view.center = self.view.center;
                //top_str_vie_por.frame=CGRectMake(24, 40, top_str_vie_por.bounds.size.width, top_str_vie_por.bounds.size.height);
            top_str_por.frame=CGRectMake(0, 0, top_str_por.bounds.size.width, top_str_por.bounds.size.height);
            
                //eve_vie_por.frame=CGRectMake(359, 324, eve_vie_por.bounds.size.width, eve_vie_por.bounds.size.height);
            eve_por.frame=CGRectMake(0, 0, eve_por.bounds.size.width, eve_por.bounds.size.height);
            
            
            
                //vid_vie_por.frame=CGRectMake(527, 324, vid_vie_por.bounds.size.width, vid_vie_por.bounds.size.height);
            vid_por.frame=CGRectMake(0, 0, vid_por.bounds.size.width, vid_por.bounds.size.height);
            
            
            
            
        }
        
        if (toInterfaceOrientation==UIInterfaceOrientationPortrait||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
            
            [self clearCurrentView];
            homeView.frame=CGRectMake(52, 171, homeView.bounds.size.width,homeView.bounds.size.height);
            [portraitView addSubview:homeView];
            
            settingView.backgrdView.frame=portraitView.frame;
            self.view.frame=portraitView.frame;
            [self.view insertSubview:portraitView atIndex:0];
            settingView.view.center = self.view.center;
                //top_str_vie_por.frame=CGRectMake(52, 171, top_str_vie_por.bounds.size.width, top_str_vie_por.bounds.size.height);
            top_str_por.frame=CGRectMake(0, 0, top_str_por.bounds.size.width, top_str_por.bounds.size.height);
            
                //eve_vie_por.frame=CGRectMake(387, 457, eve_vie_por.bounds.size.width, eve_vie_por.bounds.size.height);
            eve_por.frame=CGRectMake(0, 0, eve_por.bounds.size.width, eve_por.bounds.size.height);
            
                // vid_vie_por.frame=CGRectMake(555, 457, vid_vie_por.bounds.size.width, vid_vie_por.bounds.size.height);
            vid_por.frame=CGRectMake(0, 0, vid_por.bounds.size.width, vid_por.bounds.size.height);
        }
        
            //            timer_por=  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(flipAnimation_por) userInfo:nil repeats:YES];
            //            timer_lan=  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(flipAnimation_lan) userInfo:nil repeats:YES];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-willRotateToInterfaceOrientation Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}


#pragma mark - Memory Warning.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
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
            if([forView isEqual:@"topstory_images"])
            {
                NSDictionary *content=[json objectForKey:@"content"];
                TopStoryImages *top_content=[[DelegateClass magazine] jsonParsingForTopStoryImages:content];
                [[DelegateClass magazine] setTop_story_images:top_content._topstory_images_details];
                NSLog(@"images=%d",[DelegateClass magazine].top_story_images.count);
                NSMutableArray *array=[[NSMutableArray alloc]init];
                for (int i=0; i<[DelegateClass magazine].top_story_images.count; i++) {
                    
                    [array addObject:[[[DelegateClass magazine].top_story_images objectAtIndex:i] _image_url] ];
                }
                NSLog(@"images=%@",array);
                topstory_imageArray=[[NSMutableArray alloc] init];
                for (int i=0; i<[DelegateClass magazine].top_story_images.count; i++) {
                    
                    NSLog(@"_image_url%@",[[[DelegateClass magazine].top_story_images objectAtIndex:i] _image_url]);
                  
               
                    NSString *strUrl = [[[NSString alloc]initWithFormat:@"%@",[[[DelegateClass magazine].top_story_images objectAtIndex:i] _image_url]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
             //       NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[DelegateClass magazine].top_story_images objectAtIndex:i] _image_url]]];
                   
                    NSURL *url = [NSURL URLWithString:strUrl];

                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [UIImage imageWithData:data];
                    
                    if(img)
                        [topstory_imageArray addObject:img ];
                    else
                        NSLog(@"%@",[[[DelegateClass magazine].top_story_images objectAtIndex:i] _image_url]);
                }
                

                NSLog(@"images =%d",[DelegateClass magazine].top_story_images.count);

                NSLog(@"images =%d",topstory_imageArray.count);
                
            }
            
            if([forView isEqual:@"topstory"])
            {
                NSDictionary *content=[json objectForKey:@"content"];
                TopStory *top_content=[[DelegateClass magazine] jsonParsingForTopStory:content];
                [[DelegateClass magazine] setMg_top_story:top_content._topstory_details];
            }
            if([forView isEqual:@"tech_report"])
            {
                
                NSDictionary *content=[json objectForKey:@"content"];
                
                TopStory *top_content=[[DelegateClass magazine] jsonParsingForTopStory:content];
                
                [[DelegateClass magazine] setMg_top_story:top_content._topstory_details];
                
            }
            
            if ([forView isEqual:@"video"]) {
                NSDictionary *content=[json objectForKey:@"content"];
                Videos *video_content=[[DelegateClass magazine] jsonParsingForVideos:content];
                [[DelegateClass magazine] setMg_videos:video_content._video_details];
            }
            if ([forView isEqual:@"quiz"]) {
                NSDictionary *content=[json objectForKey:@"content"];
                Quiz *quiz_content=[[DelegateClass magazine] jsonParsingForQuiz:content];
                [[DelegateClass magazine] setMg_quiz:quiz_content._quiz_details];
            }
            if ([forView isEqual:@"gallery"]) {
                NSDictionary *content=[json objectForKey:@"content"];
                ArtOfSleeping *art_content=[[DelegateClass magazine] jsonParsingForArtOfSleeping:content];
                [[DelegateClass magazine] setMg_art_of_sleeping:art_content._gallery_details];
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

#pragma mark Button Actions

    //-(void):(id)sender {
    //    @try {
    //        if (self.settingsViewController == nil) {
    //            self.settingsViewController = [[FBUserSettingsViewController alloc] init];
    //            self.settingsViewController.delegate = self;
    //        }
    //        [self.navigationController pushViewController:self.settingsViewController animated:YES];
    //    }
    //    @catch (NSException *exception) {
    //        NSLog(@"ViewController-settingsButtonWasPressed Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    //    }
    //
    //}



-(IBAction)SettingButtonAction:(id)sender {
        //[self stopAnimation];
    @try {
            //        [timer_por invalidate];
            //        timer_por=nil;
            //        [timer_lan invalidate];
            //        timer_lan=nil;
        self.Viewcontroller=Nil;
        
        if (![DelegateClass magazine]._settingsOn) {
            settingView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            settingView.flipTimer_por=timer_por;
            settingView.flipTimer_lan=timer_lan;
                //            settingView.flipTimer_por=timer_por_art;
                //            settingView.flipTimer_lan=timer_lan_art;
            
            settingView.view.center = self.view.center;
            settingView.backgrdView.frame=self.view.frame;
            [self.view addSubview:settingView.backgrdView];
            [self.view addSubview:settingView.view];
            [DelegateClass magazine]._settingsOn = YES ;
        }
            //        else {
            //            [DelegateClass magazine]._settingsOn = NO ;
            //            [settingView.view  removeFromSuperview];
            //            [settingView.backgrdView  removeFromSuperview];
            //
            //        }
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-SettingButtonAction Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}


- (IBAction)TopStoryButtonAction:(id)sender {
    [self stopAnimation];
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
        self.Viewcontroller=Nil;
        
        
        if ([self createRequest:TopStoryURL]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading Stories...";
            _hud.mode = MBProgressHUDModeCustomView;
            [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:30.0];
            TopStoryViewController *loviewController ;
            
            loviewController = [[TopStoryViewController alloc] initWithNibName:@"TopStoryViewController_IPad" bundle:nil];
            
            self.Viewcontroller = loviewController;
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-TopStoryButtonAction Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

- (IBAction)ArtOfSleepingButtonAction:(id)sender
{
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
        self.Viewcontroller=Nil;
        if ([self createRequest:ArtOfSleep]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading Arts...";
            _hud.mode = MBProgressHUDModeCustomView;
            [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:30.0];
            ArtOfSleepingViewController *_art_of_sleeping=[[ArtOfSleepingViewController alloc]initWithNibName:@"ArtOfSleepingViewController" bundle:[NSBundle mainBundle]];
            self.Viewcontroller = _art_of_sleeping;
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-ArtOfSleepingButtonAction Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

- (IBAction)VideoButtonAction:(id)sender {
    [self stopAnimation];
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
        self.Viewcontroller=Nil;
        if ([self createRequest:VideoURL]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading Videos...";
            _hud.mode = MBProgressHUDModeCustomView;
            [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:30.0];
            VideoViewController *loVideoviewController ;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                loVideoviewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
            }
            else {
                loVideoviewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController_IPad" bundle:nil];
            }
            self.Viewcontroller = loVideoviewController;
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-VideoButtonAction Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

- (IBAction)TechButtonAction:(id)sender {
    [self stopAnimation];
    
    
    
        // TechReport *tc=[[TechReport alloc]init];
    
        // [self.navigationController pushViewController:tc
    
        //                               animated:YES];
    
    
    
    
    
    
    
    [self stopAnimation];
    
    @try {
        
        [timer_por invalidate];
        
        timer_por=nil;
        
        [timer_lan invalidate];
        
        timer_lan=nil;
        
        self.Viewcontroller=Nil;
        
        
        
        
        
        if ([self createRequest:Techreport12]) {
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            _hud.labelText = @"Loading Stories...";
            
            _hud.mode = MBProgressHUDModeCustomView;
            
            [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:30.0];
            
            TechReport *loviewController ;
            
            
            
            loviewController = [[TechReport alloc] init];
            
            
            
            self.Viewcontroller = loviewController;
            
        }else{
            
            [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            
        }
        
    }
    
    @catch (NSException *exception) {
        
        NSLog(@"ViewController-TopStoryButtonAction Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
        
    }
    
}

- (IBAction)SleepButtonAction:(id)sender {
    [self stopAnimation];
    
    SleepProfessionViewController *vc = [[SleepProfessionViewController alloc]initWithNibName:@"SleepProfessionViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)QuizButtonAction:(id)sender {
    [self stopAnimation];
    @try {
        [timer_por invalidate];
        timer_por=nil;
        [timer_lan invalidate];
        timer_lan=nil;
        QuizSectionViewController *quiz=[[QuizSectionViewController alloc]initWithNibName:@"QuizSectionViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:quiz animated:YES];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"ViewController-QuizButtonAction Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

- (IBAction)LinkedinButtonAction:(id)sender {
    [self stopAnimation];
    [timer_por invalidate];
    timer_por=nil;
    [timer_lan invalidate];
    timer_lan=nil;
    self.Viewcontroller=Nil;
    if ([self checkConnection]) {
        LinkedinViewController *linkedinviewController = [[LinkedinViewController alloc] initWithNibName:@"LinkedinViewController" bundle:nil];
        LinkedInLoginViewController *linkedinloginviewController = [[LinkedInLoginViewController alloc] initWithNibName:@"LinkedInLoginViewController" bundle:nil];
        
        if([DelegateClass magazine]._userURL){
            self.Viewcontroller = linkedinviewController;
            [self.navigationController presentModalViewController:self.Viewcontroller animated:YES];
        }
        else
        {
            NSString *logged=[NSString stringWithFormat:@"You have logged in through %@. Do you want to login through LinkedIn ?",[DelegateClass magazine]._loggedThrough];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Login" message:logged delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            alert.tag=100;
            [alert show];
            
            
            self.Viewcontroller = linkedinloginviewController;
            
        }
        
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex != [alertView cancelButtonIndex] ) {
            [self.navigationController presentModalViewController:self.Viewcontroller animated:YES];
        }
    }
    [self viewDidAppear:YES];
    
}
- (IBAction)FaceBookButtonAction:(id)sender {
    
    
}
- (IBAction)TwitterButtonAction:(id)sender {
    
    
}


@end
