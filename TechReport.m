#import "TechReport.h"
#import "SettingsViewController.h"
#import "DelegateClass.h"
#import "ImageScrollingViewController.h"
#import "NetworkCheck.h"

@interface TechReport ()
@property (nonatomic, strong)SettingsViewController *settingView;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage_face_por;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage_face_lan;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage_twit_por;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage_twit_lan;
@property (nonatomic,strong) IBOutlet UIButton *mSettingBtn;
@property (nonatomic,strong) IBOutlet UILabel *mUserNameLabel_por;
@property (nonatomic,strong) IBOutlet UILabel *mUserNameLabel_lan;

@end

@implementation TechReport
@synthesize landscape;
@synthesize imageSlideView;
@synthesize portrait;
@synthesize topStories;
@synthesize myWebView;
@synthesize modelArray;
@synthesize mSettingBtn;
@synthesize mUserNameLabel_por=_mUserNameLabel_por;
@synthesize mUserNameLabel_lan=_mUserNameLabel_lan;
@synthesize userProfileImage_face_por = _userProfileImage_face_por;
@synthesize userProfileImage_twit_por = _userProfileImage_twit_por;
@synthesize userProfileImage_face_lan = _userProfileImage_face_lan;
@synthesize userProfileImage_twit_lan = _userProfileImage_twit_lan;
@synthesize settingView;
@synthesize contentArray;
@synthesize hud=_hud;
@synthesize Viewcontroller=_Viewcontroller;

BOOL landscapeView1 = NO;


- (void)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedCon= (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedCon.selectedSegmentIndex;
    index_segment=selectedSegment;
    if (selectedSegment == 0) {
        
        [myWebView loadHTMLString:[[[topStories objectAtIndex:index_for_data] _article_url] stringByDecodingHTMLEntities] baseURL:nil];
            //toggle the correct view to be visible
        
    }
    else if(selectedSegment == 1){
        [myWebView loadHTMLString:[[[topStories objectAtIndex:index_for_data] _figue_url] stringByDecodingHTMLEntities] baseURL:nil];
            //toggle the correct view to be visible
        
        
    }else
    {
        [myWebView loadHTMLString:[[[topStories objectAtIndex:index_for_data] _reference_url] stringByDecodingHTMLEntities] baseURL:nil];
    }
}
- (IBAction)SettingButtonActionInTopStoryScrren:(id)sender {
    
    @try {
        if (![DelegateClass magazine]._settingsOn) {
            settingView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
                // settingView.view.bounds=CGRectMake(0, 0, 320, 320);
            settingView.view.center = self.view.center;
            settingView.backgrdView.frame=self.view.frame;
            [self.view addSubview:settingView.backgrdView];
            [self.view addSubview:settingView.view];
            [[NSUserDefaults standardUserDefaults] setObject:@"TopStroryScreen" forKey:@"SettingViewAppeared"];
            [DelegateClass magazine]._settingsOn=YES;
                // [moviePlayer pause];
        }
        else {
                //[moviePlayer prepareToPlay];
                // [moviePlayer play];
            
                //            [DelegateClass magazine]._settingsOn = NO;
                //
                //            [settingView.view  removeFromSuperview];
                //            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"SettingViewAppeared"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-SettingButtonActionInTopStoryScrren Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
    
}

#pragma mark - ImageSlideSHOW

-(void)goToImageScrolling:(NSNotification *)obj
{
    @try {
        NSLog(@"%@",[obj userInfo]);
        
        ImageScrollingViewController *_imageScrolling=[[ImageScrollingViewController alloc]initWithNibName:@"ImageScrollingViewController" bundle:[NSBundle mainBundle]];
        _imageScrolling.Image =[NSString stringWithFormat:@"%@",[obj userInfo]];
        _imageScrolling.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        
        _imageScrolling.imageData=[DelegateClass magazine]._imageData;
            //  [obj observationInfo];
        
        [self presentModalViewController:_imageScrolling animated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageScrolling" object:obj];
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-goToImageScrolling Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
        //    CATransition *applicationLoadViewIn =[CATransition animation];
        //    [applicationLoadViewIn setDuration:1.0];
        //    [applicationLoadViewIn setType:kCATransitionReveal];
        //    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        //    [[_imageScrolling.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        //    [self.view addSubview:_imageScrolling.view];
}

-(void)showImages:(id)sender
{
    @try {
        if (![DelegateClass magazine]._slideShowOn) {
            imageSlideView = [[ImageSlideshowViewController alloc] initWithNibName:@"ImageSlideshowViewController" bundle:nil];
            
            imageSlideView.view.center = self.view.center;
            imageSlideView.backgrdView.frame=self.view.frame;
            [self.view addSubview:imageSlideView.backgrdView];
            [self.view addSubview:imageSlideView.view];
            [DelegateClass magazine]._slideShowOn = YES ;
        }
        else {
            [DelegateClass magazine]._slideShowOn = NO ;
            [imageSlideView.view  removeFromSuperview];
            [imageSlideView.backgrdView  removeFromSuperview];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-showImages Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

    //- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
    //{
    //    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    //    {
    //        NSLog(@"req: %@",request.URL.absoluteString);
    //    }
    //
    //
    //return YES;
    //}

#pragma mark - Connection methods

-(void)didReceivedErrorFromWebView:(NSString *)result
{
    @try {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection" message:result delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:1.0];
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-didReceivedErrorFromWebView Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}
-(void)didReceivedContentFromWebView:(NSMutableArray *)result
{
    @try {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:1.0];
        NSLog(@"%@",[DelegateClass magazine].mg_gallery);
        
        [self showImages:result];
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-didReceivedContentFromWebView Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}


#pragma mark - Hud View

- (void)dismissHUD:(id)arg {
    @try {
        if ([(NSString *)arg isEqual:@"Time Out"]) {
            [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Timed Out!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        [_request_gallery cancelPreviousRequest];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        self.hud = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-dismissHUD Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}

#pragma mark - Web View Delegates


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    @try {
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            
            NSString *requestURL=request.URL.absoluteString;
            NSRange end = [requestURL rangeOfString:@"button:"];
            NSLog(@"req: %@",requestURL);
            if (end.location != NSNotFound)
            {
                requestURL = [requestURL stringByReplacingOccurrencesOfString:@"button:"
                                                                   withString:@"http:"];
                NSLog(@"req: %@",requestURL);
                    // check if the url requests starts with our custom protocol:
                
                _request_gallery=[[GalleryRequest alloc]initWithDelegate:self];
                if ([_request_gallery sendRequest:requestURL]) {
                    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    _hud.labelText = @"Loading Images...";
                    _hud.mode = MBProgressHUDModeCustomView;
                    [self performSelector:@selector(dismissHUD:) withObject:@"Time Out" afterDelay:30.0];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"Check Internet Connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                }
                
                
                
                
                return NO;
            }
            
        }
        
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-shouldStartLoadWithRequest Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
    
}


NSURL *fileUrl;

    //- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //
    //    NSURL *clickedURL = [request URL];
    //    NSString *clickedURLString =[NSString stringWithFormat:@"%@",clickedURL];
    //    NSString* checkURLValid = [clickedURL host];
    //    NSString* schemeOfURLClicked = [clickedURL scheme];
    //    NSLog(@"%@",clickedURLString);
    //}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
        //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Internet Connection" message:@"check internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        //    [alert show];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
        //    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        //    _hud.labelText = @"Loading TopStory...";
        //    _hud.mode = MBProgressHUDModeCustomView;
        //    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:30.0];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
        //    [NSObject cancelPreviousPerformRequestsWithTarget:self];
        //    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:1.0];
        //    CGRect frame = myWebView.frame;
        //    frame.size.height = 1;
        //    myWebView.frame = frame;
        //    CGSize fittingSize = [myWebView sizeThatFits:CGSizeZero];
        //    frame.size = fittingSize;
        //    myWebView.frame = frame;
        //
        //    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    
    
}
-(void)frountPage
{
    @try {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation  == UIInterfaceOrientationLandscapeRight) {
            [self clearCurrentView];
            
            headingLableLand.text=[[topStories objectAtIndex:index_for_data] _heading];
            sub_headingLableLand.text=[[topStories objectAtIndex:index_for_data] _sub_heading];
            self.view.frame=landscape.frame;
            myWebView.frame=CGRectMake(29, 130.0, 1004.0-55, 600.0);
            self.view.frame=landscape.frame;
            imageSlideView.view.center=self.view.center;
            imageSlideView.backgrdView.frame=landscape.frame;
            [self.view insertSubview:landscape atIndex:0];
            landscapeView1=YES;
        }else
        {
            
            headingLablePort.text=[[topStories objectAtIndex:index_for_data] _heading];
            sub_headingLablePort.text=[[topStories objectAtIndex:index_for_data] _sub_heading];
            
            [self clearCurrentView];
            
            self.view.frame=portrait.frame;
            myWebView.frame=CGRectMake(29, 130.0, 768.0-55, 855.0);
            self.view.frame=portrait.frame;
            imageSlideView.view.center=self.view.center;
            imageSlideView.backgrdView.frame=portrait.frame;
            [self.view insertSubview:portrait atIndex:0];
                // [self.view addSubview:portraitView];
            landscapeView1=NO;
        }
        
        myWebView.scalesPageToFit=YES;
            // myWebView.contentMode=UIViewContentModeScaleAspectFit;
            // myWebView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        myWebView.delegate=self;
            //    UIScrollView *scrollView = [myWebView.subviews objectAtIndex:0];
            //    scrollView.delegate = self;//self must be UIScrollViewDelegate
            //        NSString *html=[NSString stringWithFormat:@"<span \style=\"color: rgb(68, 68, 68); font-family:\ proxima-nova, sans-serif; font-size: 15px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: 21px; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); display: inline !important; float: none;\">                        <img src=\"http://i.imgur.com/Nv5DcqF.jpg\" width=\"259\">\ When using the TinyMCE editor, I click on the image link and see a popup window. Clicking on the browser button for the Image URL box, I get another window open, but the window looks incomplete and lists no files.\ I cannot move to another folder, nor can I upload any images</span>"];
            //        NSString *path=[[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
            //        fileUrl=[NSURL fileURLWithPath:path];
            //        NSLog(@"%@",fileUrl);
        
        if (index_segment == 0) {
            
            [myWebView loadHTMLString:[[[topStories objectAtIndex:index_for_data] _article_url] stringByDecodingHTMLEntities] baseURL:nil];
                //toggle the correct view to be visible
            
        }
        if(index_segment == 1){
            [myWebView loadHTMLString:[[[topStories objectAtIndex:index_for_data] _figue_url] stringByDecodingHTMLEntities] baseURL:nil];
                //toggle the correct view to be visible
            
            
        }if(index_segment == 2){
            [myWebView loadHTMLString:[[[topStories objectAtIndex:index_for_data] _reference_url] stringByDecodingHTMLEntities] baseURL:nil];
        }
        
        segmentedControl.selectedSegmentIndex=index_segment;
            //[myWebView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreen:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToImageScrolling:) name:@"ImageScrolling" object:Nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(BackToViewControllerFromVideoScreen)
                                                     name:@"SettingLoutCalledFromTopStory"
                                                   object:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-viewWillAppear Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
        index_for_data--;
    }
    
}
-(void)nextPage:(int)sender
{
    NSLog(@"next.tag==%d",next.tag);
    
    if(next.tag==4)
        return;
    
    index_for_data++;
    next.tag=index_for_data;
    previous.tag=index_for_data;
    [self frountPage];
}
-(void)previousPage:(int)sender
{
    NSLog(@"previous.tag==%d",previous.tag);
    if(previous.tag==0)
        return;
    
    index_for_data--;
    next.tag=index_for_data;
    previous.tag=index_for_data;
    [self frountPage];
}
#pragma mark - View lifecycle

-(void) clearCurrentView {
    @try {
            // [topstoryimage removeFromSuperview];
        
        if (landscape.superview) {
            
            [landscape removeFromSuperview];
            
        } else if (portrait.superview) {
            
            [portrait removeFromSuperview];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-clearCurrentView Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

- (void)viewDidLoad
{
    
    index_for_data=[DelegateClass magazine].fadeImageIndex;
   
    [super viewDidLoad];
     
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)didReceiveResponseFromServer:(NSString *)responseData
{
    
    NSData *data = [responseData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *json=[[NSDictionary alloc]init];
    json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@",responseData);
    NSDictionary *content=[json objectForKey:@"content"];
    NSString *html;
    for (NSDictionary *temp in content) {
        html=[temp objectForKey:@"figure"] ;
        html=[html stringByDecodingHTMLEntities];
        
        NSLog(@"%@",html);
        
    }
    
        //[myWebView loadHTMLString:html baseURL:nil];
        // NSString *html=[NSString stringWithFormat:@"%@",content];
    
        // Append the new data to receivedData.
        // receivedData is an instance variable declared elsewhere.
    
        // NSString* title = [myWebView stringByEvaluatingJavaScriptFromString: @"document.getElementByID('hello').value"];
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

-(void)segmentAction:(id)sender{
    
    
    
    switch (segmentedControl2.selectedSegmentIndex) {
            
        case 0:
            
            NSLog(@"previous");
            if(index_for_data==0)
                return;
            
            index_for_data--;
            
            [self frountPage];
            
            
            break;
            
        case 1:
            
            NSLog(@"next");
            if(index_for_data==50)
                return;
            
            index_for_data++;
            
            [self frountPage];
            break;
            
            
            
        default:
            
            break;
            
    }
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    @try {
        [super viewWillAppear:animated];
       
        [segmentedControl removeFromSuperview];
        
        UISegmentedControl * seg1 = [[UISegmentedControl alloc]
                                     initWithItems:[NSArray arrayWithObjects:@"Article", @"Figures",@"References", nil]];
        [seg1 setSegmentedControlStyle:UISegmentedControlStyleBar];
        [seg1 addTarget:self action:@selector(segmentSwitch:) forControlEvents: UIControlEventValueChanged];
             self.navigationItem.titleView = seg1;
            //    self.navigationItem.titleView=segmentedControl;
            //        if ([self createRequest:@"http://182.50.141.148/iphonequiz/topstory.php"]) {
            //        }
        
        
            //setting button
        
        /*     UIImage *buttonImage = [UIImage imageNamed:@"setting icon1.png"];
         aButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [aButton setImage:buttonImage forState:UIControlStateNormal];
         aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
         
         // Initialize the UIBarButtonItem
         UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
         
         // Set the Target and Action for aButton
         [aButton addTarget:self action:@selector(SettingButtonActionInTopStoryScrren:) forControlEvents:UIControlEventTouchUpInside];
         */
        
            //share button
        shareButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharing)];
        
            //segment button second
        /*     segmentedControl2.frame = CGRectMake(0, 0, 150, 30);
         segmentedControl2.tag=index_for_data;
         UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl2];
         self.navigationItem.rightBarButtonItem = segmentBarItem;
         */
        
            //        next = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain                                                                target:self action:@selector(nextPage:)];
            //        next.tag=index_for_data;
            //        previous = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain                                                                      target:self action:@selector(previousPage:)];
            //        previous.tag=index_for_data;
        
        
            // Set the Target and Action for aButton
            //[shareButton addTarget:self action:@selector(setNetworkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectMake(0.0, 0, 140, 44.0);
        
        UIToolbar* fieldAccessoryView = [[UIToolbar alloc] initWithFrame:frame];
        
            //  fieldAccessoryView.barStyle = UIBarStyleBlackOpaque;
        
        fieldAccessoryView.tag = 200;
        fieldAccessoryView.tintColor=[UIColor colorWithRed:118.0f/255.0f green:141.0f/255.0f blue:176.0f/255.0f alpha:1.0];
        
        
        
            //   [fieldAccessoryView setBarStyle:UIBarStyleBlack];
        
        
        
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
            //  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(done:)];
        
        
        
        segmentedControl2 = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Previous", @""), NSLocalizedString(@"Next", @""), nil]];
        
        [segmentedControl2 addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
        segmentedControl2.segmentedControlStyle = UISegmentedControlStyleBar;
        
        [segmentedControl2 setMomentary:YES];
        
        UIBarButtonItem *segmentButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl2];
        
        
        
        [fieldAccessoryView setItems:[NSArray arrayWithObjects:segmentButton, spaceButton, nil] animated:NO];
        
        UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:fieldAccessoryView];
            //self.navigationItem.leftBarButtonItem = twoButtons;
        
        
        
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:shareButton1,twoButtons, nil];
        
        
            //return [view convertRect:view.bounds toView:nil];
        
            //////
        topStories=[[NSMutableArray alloc]init];
        topStories=[DelegateClass magazine].mg_top_story;
        
        NSLog(@"tt=%@",[DelegateClass magazine].mg_top_story);
        
            //Instantiate the model array
        self.modelArray = [[NSMutableArray alloc] init];
        self.contentArray = [[NSMutableArray alloc] init];
        for (int index = 1; index <=[topStories count] ; index++)
        {
            NSString *path;
            NSBundle *bundle = [NSBundle mainBundle];
            path = [bundle pathForResource:@"index" ofType:@"html"];
            
            [self.modelArray addObject:[NSString stringWithFormat:@"page %d",index]];
                // web.scalesPageToFit=YES;
            
            [self.contentArray addObject:[[topStories objectAtIndex:index-1] _figue_url]];
        }
        NSLog(@"%@",self.contentArray);
        
            //Step 1
            //Instantiate the UIPageViewController.
        
        fileUrl = [NSURL URLWithString:[self.contentArray objectAtIndex:0]];
            //Step 4:
            //ViewController containment steps
            //Add the pageViewController as the childViewController
        
        
            //Step 5:
            // set the pageViewController's frame as an inset rect.
        
        
            //Step 6:
            //Assign the gestureRecognizers property of our pageViewController to our view's gestureRecognizers property.
        
        self.mUserNameLabel_lan.text =  @"";
        self.mUserNameLabel_lan.text =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"];
        self.mUserNameLabel_por.text =  @"";
        self.mUserNameLabel_por.text =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"userName"];
        [DelegateClass magazine]._settingsOn=NO;
        self.userProfileImage_face_por.hidden=YES;
        self.userProfileImage_face_lan.hidden=YES;
            // [super viewWillAppear:animated];
        if ([[DelegateClass magazine]._loggedThrough isEqual:@"Facebook"]) {
            
            self.userProfileImage_twit_lan.hidden=YES;
            self.userProfileImage_face_lan.profileID=[DelegateClass magazine]._profImage;
            self.userProfileImage_face_lan.hidden=NO;
            self.userProfileImage_twit_por.hidden=YES;
            self.userProfileImage_face_por.profileID=[DelegateClass magazine]._profImage;
            self.userProfileImage_face_por.hidden=NO;
            
        }else if ([[DelegateClass magazine]._loggedThrough isEqual:@"Twitter"]) {
            self.userProfileImage_face_lan.hidden=YES;
            self.userProfileImage_twit_lan.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._profImage]]];
            self.userProfileImage_twit_lan.hidden=NO;
            
            self.userProfileImage_face_por.hidden=YES;
            self.userProfileImage_twit_por.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._profImage]]];
            self.userProfileImage_twit_por.hidden=NO;
        } else if ([[DelegateClass magazine]._loggedThrough isEqual:@"LinkedIn"]) {
            self.userProfileImage_face_lan.hidden=YES;
            self.userProfileImage_twit_lan.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._linkedinUrl]]];
            self.userProfileImage_twit_lan.hidden=NO;
            self.userProfileImage_face_por.hidden=YES;
            self.userProfileImage_twit_por.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DelegateClass magazine]._linkedinUrl]]];
            self.userProfileImage_twit_por.hidden=NO;
        }
        
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation  == UIInterfaceOrientationLandscapeRight) {
            
            [self clearCurrentView];
            
            
            
            headingLableLand.text=[[topStories objectAtIndex:index_for_data] _heading];
            NSLog(@"int %i",index_for_data);
            
            NSLog(@"heading %@",headingLableLand.text);
            
            
            sub_headingLableLand.text=[[topStories objectAtIndex:index_for_data] _sub_heading];
             NSLog(@"heading %@",sub_headingLableLand.text);
            
            
            self.view.frame=landscape.frame;
            
            
            myWebView.frame=CGRectMake(29, 130.0, 1004.0-55, 600.0);
            
            self.view.frame=landscape.frame;
            
            imageSlideView.view.center=self.view.center;
            
            imageSlideView.backgrdView.frame=landscape.frame;
            
            [self.view insertSubview:landscape atIndex:0];
            
            landscapeView1=YES;
            
        }else
            
        {
            
            [self clearCurrentView];
            
            headingLablePort.text=[[topStories objectAtIndex:index_for_data] _heading];
             NSLog(@"heading %@",headingLablePort.text);
            sub_headingLablePort.text=[[topStories objectAtIndex:index_for_data] _sub_heading];
             NSLog(@"heading %@",sub_headingLablePort.text);
            self.view.frame=portrait.frame;
            
            
            myWebView.frame=CGRectMake(29, 130.0, 768.0-55, 855.0);
            
            self.view.frame=portrait.frame;
            
            imageSlideView.view.center=self.view.center;
            
            imageSlideView.backgrdView.frame=portrait.frame;
            
            [self.view insertSubview:portrait atIndex:0];
            
             //    [self.view addSubview:portrait];
            
            landscapeView1=NO;
            
        }
        myWebView.scalesPageToFit=YES;
            // myWebView.contentMode=UIViewContentModeScaleAspectFit;
            // myWebView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        myWebView.delegate=self;
            //    UIScrollView *scrollView = [myWebView.subviews objectAtIndex:0];
            //    scrollView.delegate = self;//self must be UIScrollViewDelegate
            //        NSString *html=[NSString stringWithFormat:@"<span \style=\"color: rgb(68, 68, 68); font-family:\ proxima-nova, sans-serif; font-size: 15px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: 21px; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); display: inline !important; float: none;\">                        <img src=\"http://i.imgur.com/Nv5DcqF.jpg\" width=\"259\">\ When using the TinyMCE editor, I click on the image link and see a popup window. Clicking on the browser button for the Image URL box, I get another window open, but the window looks incomplete and lists no files.\ I cannot move to another folder, nor can I upload any images</span>"];
            //        NSString *path=[[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
            //        fileUrl=[NSURL fileURLWithPath:path];
            //        NSLog(@"%@",fileUrl);
        
        
        
        [myWebView loadHTMLString:[[[topStories objectAtIndex:index_for_data] _article_url] stringByDecodingHTMLEntities] baseURL:nil];
        segmentedControl.selectedSegmentIndex=0;
            //[myWebView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreen:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToImageScrolling:) name:@"ImageScrolling" object:Nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(BackToViewControllerFromVideoScreen)
                                                     name:@"SettingLoutCalledFromTopStory"
                                                   object:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-viewWillAppear Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}
- (void)BackToViewControllerFromVideoScreen {
    @try {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SettingLoutCalledFromTopStory" object:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"VideoViewController-BackToViewControllerFromVideoScreen Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}
-(void)sharing{
    
    if([UIActivityViewController class]){
        
        
        
        if ([self.activityPopoverController isPopoverVisible]) {
            [self.activityPopoverController dismissPopoverAnimated:YES];
        } else {
                //        NSArray *activityItems = @[
                //        @"http://www.sleepdt.com/introducing-a-novel-micro-recorder-for-the-detection-of-oral-appliance-compliance-dentitrac-2/",
                //        @"http://www.sleepdt.com/small-product-big-dreams/",
                //        @"http://www.sleepdt.com/the-battle-for-oral-appliance-legitimacy/",
                //        @"http://www.sleepdt.com/home-sleep-testing-continues-its-momentum/",
                //        @"http://www.sleepdt.com/a-novel-non-prescription-nasal-epap-device-theravent-to-treat-snoring/",@"http://www.sleepdt.com/the-video-advantage/",@"http://www.sleepdt.com/changes-in-the-heart-rate-variability-in-patients-with-obstructive-sleep-apnea-and-its-response-to-acute-cpap-treatment-2/",
                //        ];
            
            NSArray *activityItems1=[NSArray arrayWithObject:[[topStories objectAtIndex:index_for_data] _page_url]];
            NSArray *applicationActivities = @[
            [[GSSampleActivity alloc] init],
            ];
            
            UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems1
                                                                             applicationActivities:applicationActivities];
            vc.completionHandler = ^(NSString *activityType, BOOL completed){
                [self.activityPopoverController dismissPopoverAnimated:YES];
            };
            
            if (self.activityPopoverController) {
                [self.activityPopoverController setContentViewController:vc];
            } else {
                self.activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
            }
            CGRect popRect;
            if ([UIApplication sharedApplication].statusBarOrientation ==UIInterfaceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
                popRect = CGRectMake(980,-20,0,0);
            }else{
                popRect = CGRectMake(740,-20,0,0);
                
            }
            
            
            [self.activityPopoverController presentPopoverFromRect:popRect
                                                            inView:self.view
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
        }
        
    }
    else{
        return;
        
    }
    
}

- (void)setNetworkButtonTapped:(UIButton *)sender
{
    @try {
        if ([self.networkPickerPopover isPopoverVisible]) {
            [self.networkPickerPopover dismissPopoverAnimated:YES];
        } else {
            self.networkPicker = [[SharingViewController alloc]
                                  initWithStyle:UITableViewStylePlain] ;
            _networkPicker.delegate = self;
            self.networkPickerPopover = [[UIPopoverController alloc]
                                         initWithContentViewController:_networkPicker] ;
                //the rectangle here is the frame of the object that presents the popover,
                //in this case, the UIButton…
            CGRect popRect = CGRectMake(aButton.frame.origin.x-40,
                                        -40,
                                        aButton.frame.size.width,
                                        aButton.frame.size.height);
            
            
            
                //            [self.networkPickerPopover presentPopoverFromRect:popRect
                //                                                       inView:questionView
                //                                     permittedArrowDirections:UIPopoverArrowDirectionAny
                //                                                     animated:YES];
            [self.networkPickerPopover presentPopoverFromRect:popRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"QuizViewController-setNetworkButtonTapped Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
}

#pragma mark : Protocol Methods

/*
 - (void)socialNetworkSelected:(NSString *)networkName {
 @try {
 BOOL posted = FALSE;
 if ([networkName compare:@"Gmail"] == NSOrderedSame) {
 NSLog(@"gmail sharing");
 //            if (![added_result_lab.text isEqualToString:@""]) {
 //                NSString *post_message=[NSString stringWithFormat:@"My Score in Sleep Professional iPad App is %@",added_result_lab.text];
 //
 //                [self sendMailButtonAction:post_message];
 //                [self.networkPickerPopover dismissPopoverAnimated:YES];
 //                posted = TRUE;
 //            }
 
 
 } else if ([networkName compare:@"Facebook"] == NSOrderedSame && [[DelegateClass magazine]._loggedThrough isEqualToString:networkName]){
 NSLog(@"Facebook sharing");
 //            if (![added_result_lab.text isEqualToString:@""]) {
 //                NSString *post_message=[NSString stringWithFormat:@"My Score in Sleep Professional iPad App is %@",added_result_lab.text];
 //                [self.postParams setObject:post_message
 //                                    forKey:@"message"];
 //                [self shareActionFacebook];
 //                [self.networkPickerPopover dismissPopoverAnimated:YES];
 //                posted = TRUE;
 //            }
 
 
 } else if ([networkName compare:@"Twitter"] == NSOrderedSame && [[DelegateClass magazine]._loggedThrough isEqualToString:networkName]){
 NSLog(@"Twitter sharing");
 
 //            if (![added_result_lab.text isEqualToString:@""]) {
 //                NSString *post_message=[NSString stringWithFormat:@"My Score in Sleep Professional iPad App is %@",added_result_lab.text];
 //                [self publishStoryInTwitter:post_message];
 //                [self.networkPickerPopover dismissPopoverAnimated:YES];
 //                posted = TRUE;
 //            }
 
 
 }else if ([networkName compare:@"LinkedIn"] == NSOrderedSame && [[DelegateClass magazine]._loggedThrough isEqualToString:networkName])
 {
 NSLog(@"LinkedIn sharing");
 //            if (![added_result_lab.text isEqualToString:@""]) {
 //                NSString *post_message=[NSString stringWithFormat:@"My Score in Sleep Professional iPad App is %@",added_result_lab.text];
 //                [[LinkedIn linked] postButton_TouchUp:post_message];
 //                [self.networkPickerPopover dismissPopoverAnimated:YES];
 //                posted = TRUE;
 //            }
 
 }
 if (!posted) {
 NSString *msg=[NSString stringWithFormat:@"You are logged in through %@",[DelegateClass magazine]._loggedThrough];
 UIAlertView *_alert_view=[[UIAlertView alloc]initWithTitle:@"Post Failure" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
 [_alert_view show];
 }
 }
 @catch (NSException *exception) {
 NSLog(@"QuizViewController-socialNetworkSelected Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
 }
 
 
 }
 */

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    @try {
        [super viewWillDisappear:animated];
        [myWebView reload];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:Nil];
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-viewWillDisappear Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
	
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
            // Custom initialization
        
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}



#pragma mark - Touch Event Methods

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    @try {
        UITouch *touch = [[event allTouches]anyObject];
        CGPoint point = [touch locationInView:imageSlideView.backgrdView];
        point=CGPointMake(point.x+10, point.y+10);
        
        
        if([imageSlideView.backgrdView pointInside:point withEvent:event])
        {
            UITouch *touch=[touches anyObject];
            if([touch tapCount] == 1) {
                [imageSlideView backButtonAction];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-touchesBegan Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
    
}
/*
 -(void)moviePlayerWillExitFullscreen:(NSNotification*)notification
 {
 NSLog(@"frame %@",NSStringFromCGRect(self.view.frame));
 CGFloat ratioAspect = self.myWebView.bounds.size.width/self.myWebView.bounds.size.height;
 myWebView.scalesPageToFit=YES;
 if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation  == UIInterfaceOrientationLandscapeRight) {
 
 [self clearCurrentView];
 self.view.frame=landscape.frame;
 settingView.backgrdView.frame=landscape.frame;
 [self.view insertSubview:landscape atIndex:0];
 settingView.view.center=self.view.center;
 myWebView.frame=CGRectMake(0.0, 100.0, 1004.0, 600.0);
 imageSlideView.view.center=self.view.center;
 imageSlideView.backgrdView.frame=landscape.frame;
 
 
 
 for (UIScrollView *scroll in [self.myWebView subviews]) { //we get the scrollview
 // Make sure it really is a scroll view and reset the zoom scale.
 if ([self.myWebView.scrollView respondsToSelector:@selector(setZoomScale:)]){
 self.myWebView.scrollView.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
 self.myWebView.scrollView.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
 [self.myWebView.scrollView setZoomScale:0.0f animated:YES];
 }
 }
 
 }
 if ([UIDevice currentDevice].orientation==UIInterfaceOrientationPortrait || [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
 [self clearCurrentView];
 self.view.frame=portrait.frame;
 settingView.backgrdView.frame=portrait.frame;
 [self.view insertSubview:portrait atIndex:0];
 settingView.view.center=self.view.center;
 imageSlideView.view.center=self.view.center;
 imageSlideView.backgrdView.frame=portrait.frame;
 myWebView.frame=CGRectMake(0.0, 124.0, 768.0, 830.0);
 settingView.view.center=self.view.center;
 // [self.view addSubview:portraitView];
 
 for (UIScrollView *scroll in [self.myWebView subviews]) { //we get the scrollview
 // Make sure it really is a scroll view and reset the zoom scale.
 if ([self.myWebView.scrollView respondsToSelector:@selector(setZoomScale:)]){
 self.myWebView.scrollView.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
 self.myWebView.scrollView.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
 [self.myWebView.scrollView setZoomScale:0.0f animated:YES];
 }
 }
 
 }
 
 self.navigationController.navigationBar.frame = CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
 }
 */
    //- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    //    return nil;
    //}

#pragma mark - Interface Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    [self.networkPickerPopover dismissPopoverAnimated:YES];
    
    
    return YES;
}
/*
 - (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 NSLog(@"frame %@",NSStringFromCGRect(self.view.frame));
 CGFloat ratioAspect = self.myWebView.bounds.size.width/self.myWebView.bounds.size.height;
 myWebView.scalesPageToFit=YES;
 if (toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
 if(!landscapeView)
 {
 [self clearCurrentView];
 self.view.frame=landscape.frame;
 settingView.backgrdView.frame=landscape.frame;
 [self.view insertSubview:landscape atIndex:0];
 settingView.view.center=self.view.center;
 myWebView.frame=CGRectMake(0.0, 100.0, 1004.0, 600.0);
 imageSlideView.view.center=self.view.center;
 imageSlideView.backgrdView.frame=landscape.frame;
 
 
 
 for (UIScrollView *scroll in [self.myWebView subviews]) { //we get the scrollview
 // Make sure it really is a scroll view and reset the zoom scale.
 if ([self.myWebView.scrollView respondsToSelector:@selector(setZoomScale:)]){
 self.myWebView.scrollView.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
 self.myWebView.scrollView.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
 [self.myWebView.scrollView setZoomScale:0.0f animated:YES];
 }
 }
 
 landscapeView=YES;
 }
 
 }
 if (toInterfaceOrientation==UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
 if (landscapeView) {
 [self clearCurrentView];
 self.view.frame=portrait.frame;
 settingView.backgrdView.frame=portrait.frame;
 [self.view insertSubview:portrait atIndex:0];
 settingView.view.center=self.view.center;
 imageSlideView.view.center=self.view.center;
 imageSlideView.backgrdView.frame=portrait.frame;
 myWebView.frame=CGRectMake(0.0, 124.0, 768.0, 830.0);
 settingView.view.center=self.view.center;
 // [self.view addSubview:portraitView];
 
 for (UIScrollView *scroll in [self.myWebView subviews]) { //we get the scrollview
 // Make sure it really is a scroll view and reset the zoom scale.
 if ([self.myWebView.scrollView respondsToSelector:@selector(setZoomScale:)]){
 self.myWebView.scrollView.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
 self.myWebView.scrollView.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
 [self.myWebView.scrollView setZoomScale:0.0f animated:YES];
 }
 }
 landscapeView=NO;
 }
 
 
 }
 
 
 
 }
 */
-(void)moviePlayerWillExitFullscreen:(NSNotification*)notification
{
    @try {
        NSLog(@"frame %@",NSStringFromCGRect(self.view.frame));
        CGFloat ratioAspect = self.myWebView.bounds.size.width/self.myWebView.bounds.size.height;
        
        if ([UIApplication sharedApplication].statusBarOrientation ==UIInterfaceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
            [self.activityPopoverController dismissPopoverAnimated:YES];
            if(!landscapeView1)
            {
                [self clearCurrentView];
                headingLableLand.text=[[topStories objectAtIndex:index_for_data] _heading];
                sub_headingLableLand.text=[[topStories objectAtIndex:index_for_data] _sub_heading];
                self.view.frame=landscape.frame;
                settingView.backgrdView.frame=landscape.frame;
                [self.view insertSubview:landscape atIndex:0];
                settingView.view.center=self.view.center;
                myWebView.frame=CGRectMake(29.0, 130.0, 1004.0-55, 600.0);
                imageSlideView.view.center=self.view.center;
                imageSlideView.backgrdView.frame=landscape.frame;
                
                
                
                for (UIScrollView *scroll in [self.myWebView subviews]) { //we get the scrollview
                                                                          // Make sure it really is a scroll view and reset the zoom scale.
                    if ([self.myWebView.scrollView respondsToSelector:@selector(setZoomScale:)]){
                        self.myWebView.scrollView.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
                        self.myWebView.scrollView.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
                            //[self.myWebView.scrollView setZoomScale:0.0f animated:YES];
                    }
                }
                
                landscapeView1=YES;
            }
            
        }
        if ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            if (landscapeView1) {
                [self.activityPopoverController dismissPopoverAnimated:YES];
                [self clearCurrentView];
                headingLablePort.text=[[topStories objectAtIndex:index_for_data] _heading];
                sub_headingLablePort.text=[[topStories objectAtIndex:index_for_data] _sub_heading];
                
                self.view.frame=portrait.frame;
                settingView.backgrdView.frame=portrait.frame;
                [self.view insertSubview:portrait atIndex:0];
                settingView.view.center=self.view.center;
                imageSlideView.view.center=self.view.center;
                imageSlideView.backgrdView.frame=portrait.frame;
                myWebView.frame=CGRectMake(29, 130.0, 768.0-55, 855.0);
                settingView.view.center=self.view.center;
                    // [self.view addSubview:portraitView];
                
                for (UIScrollView *scroll in [self.myWebView subviews]) { //we get the scrollview
                                                                          // Make sure it really is a scroll view and reset the zoom scale.
                    if ([self.myWebView.scrollView respondsToSelector:@selector(setZoomScale:)]){
                        self.myWebView.scrollView.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
                        self.myWebView.scrollView.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
                            //[self.myWebView.scrollView setZoomScale:0.0f animated:YES];
                    }
                }
                landscapeView1=NO;
            }
            
            
        }
        myWebView.scalesPageToFit=YES;
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    }
    @catch (NSException *exception) {
        NSLog(@"TopStoryViewController-moviePlayerWillExitFullscreen Exception Name = %@ Exception Reason = %@",[exception name],[exception reason]);
    }
    
}

@end
