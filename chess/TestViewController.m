//
//  TestViewController.m
//
//  Copyright (c) 2014 VK.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TestViewController.h"
#import "ApiCallViewController.h"


@implementation TestViewController

@synthesize useVK = _useVK;

double timerInterval = 5.0f;

-(void) handleTimer: (NSTimer*) timer
{
    NSLog(@"Tick...");
    
    if (check == TRUE)
        return;
    
    if (check == FALSE) {
        

        NSString* strCorrentStep = [@(corentStep) stringValue];
        VKRequest *getcom = [self getComments: @{VK_API_OWNER_ID:@"176503142", VK_API_POST_ID:@"272" , VK_API_COUNT: @"1", VK_API_OFFSET: strCorrentStep/*текущий ход вставить*/}];
        getcom.debugTiming = YES;
        getcom.requestTimeout = 10;
        [getcom executeWithResultBlock: ^(VKResponse *response) {
           
            NSLog(@"Result: %@", response);
            NSString * json = response.json[@"items"];
            NSLog(@"ALL GOOD + text:%@", json);
  
            NSArray *smg = json;
            NSSet *setObj1 = [NSSet setWithArray:smg];
            //make the nsset for my array (named :smg)
            
            NSString *pars = [[setObj1 allObjects] componentsJoinedByString:@","];
            //make the string from all the sets joined by ","
            
            NSArray * bits = [pars componentsSeparatedByString:@" = "];
            NSLog(@"bits: %@", bits);
            
            NSString *step = [bits lastObject];
            NSArray *temp = [step componentsSeparatedByString:@";"];
            
            NSString *myStep = temp[0];
            
            NSLog(@"my step: %@", myStep);
            
            
            NSArray *parser = [myStep componentsSeparatedByString:@" "];
            NSString *tmp = [parser objectAtIndex:0];
            NSArray *tempParser = [tmp componentsSeparatedByString:@"\""];
            if([tempParser count] == 1)
                return;
            tmp = [tempParser objectAtIndex:1];
            int fromX = [tmp intValue];
            NSLog(@"FromX: %d", fromX);
            tmp = [parser objectAtIndex:1];
            int fromY = [tmp intValue];
            NSLog(@"FromY: %d", fromY);
            tmp = [parser objectAtIndex:2];
            int toX = [tmp intValue];
            NSLog(@"toX: %d", toX);
            
            tmp = [parser objectAtIndex:3];
            NSArray *tmpParser = [tmp componentsSeparatedByString:@"\""];
            tmp = [tmpParser objectAtIndex:0];
            int toY = [tmp intValue];
            NSLog(@"toY: %d", toY);
            
            
            
            NSString *Step = [_gameView selectCellX:fromX Y:fromY];
            
            Step = [_gameView selectCellX:toX Y:toY];
            
            if (![Step isEqual:@"fail"]) {
                corentStep++;
                check = !check;
                NSLog(@"log %d %d", corentStep, check);
            }
            [_gameView setNeedsDisplay];
                      
        } errorBlock: ^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
  }



- (NSTimer *) timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                                  target: self
                                                selector: @selector(handleTimer:)
                                                userInfo: nil
                                                 repeats: YES];
    }
    return _timer;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"logout" style:UIBarButtonItemStyleDone target:self action:@selector(logout:)];

    BOOL b = [self.timer isValid];
    NSLog(@"timer isValid %i", b);

    firsStep = 0;
    myAccauntId = [[VKSdk getAccessToken] userId];
    if([myAccauntId isEqualToString:@"176503142"]) {
        check = FALSE;
        corentStep = 0;
        
    }
    else {
        check = TRUE;
        corentStep = 0;
    }
    
}

- (VKRequest *)prepareRequestWithMethodName:(NSString *)methodName andParameters:(NSDictionary *)methodParameters andHttpMethod:(NSString *)httpMethod {
    return [VKRequest requestWithMethod:[NSString stringWithFormat:@"%@", methodName]
                          andParameters:methodParameters
                          andHttpMethod:httpMethod];
}

- (VKRequest *)getComments:(NSDictionary *)params {
    return [self prepareRequestWithMethodName:@"wall.getComments" andParameters:params andHttpMethod:@"POST"];
}

- (VKRequest *)addComment:(NSDictionary *)params {
    return [self prepareRequestWithMethodName:@"wall.addComment" andParameters:params andHttpMethod:@"POST"];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if ([touch view]==_gameView) {
        if (check) {
            
            int cellSize= _gameView.frame.size.height/8;
            CGPoint P1 = [touch locationInView:_gameView];
            int i=P1.y/cellSize;
            int j=P1.x/cellSize;
            if(_useVK) {
                NSString *temp = [_gameView selectCellX:i Y:j];
                if (![temp isEqualToString:@"fail"]) {
                    corentStep++;
                    check = !check;
                    VKRequest *addcom = [self addComment:@{VK_API_OWNER_ID:@"176503142",VK_API_POST_ID:@"272", @"text":temp}];
                    addcom.debugTiming = YES;
                    addcom.requestTimeout = 10;
                    [addcom executeWithResultBlock: ^(VKResponse *response) {

                    } errorBlock: ^(NSError *error) {
                        NSLog(@"Error: %@", error);
                    }];
                }
            }
            else
                [_gameView selectCellX:i Y:j];
            NSLog(@"Строка - %d, столбец - %d", i, j);
        
            [_gameView setNeedsDisplay];
        }
    }
}


- (void)getUser {
	VKRequest *request = [[VKApi users] get];
	[request executeWithResultBlock: ^(VKResponse *response) {
	    NSLog(@"Result: %@", response);
	} errorBlock: ^(NSError *error) {
	    NSLog(@"Error: %@", error);
	}];
    
}

- (IBAction)getSubscriptions:(id)sender {
    VKRequest * request = [[VKApi users] getSubscriptions:@{VK_API_EXTENDED : @(1), VK_API_COUNT : @(100)}];
    request.secure = NO;
    [request executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"Result: %@", response);

    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

static NSString *const USERS_GET   = @"users.get";
static NSString *const FRIENDS_GET = @"friends.get";
static NSString *const FRIENDS_GET_FULL = @"friends.get with fields";
static NSString *const USERS_SUBSCRIPTIONS = @"Pavel Durov subscribers";
static NSString *const UPLOAD_PHOTO = @"Upload photo to wall";
static NSString *const UPLOAD_PHOTO_ALBUM = @"Upload photo to album";
static NSString *const UPLOAD_PHOTOS = @"Upload several photos to wall";
static NSString *const TEST_CAPTCHA = @"Test captcha";
static NSString *const CALL_UNKNOWN_METHOD = @"Call unknown method";
static NSString *const TEST_VALIDATION = @"Test validation";
static NSString *const MAKE_SYNCHRONOUS = @"Make synchronous request";
static NSString *const SHARE_DIALOG = @"Test share dialog";
static NSString *const TEST_ACTIVITY = @"Test VKActivity";

//Fields
static NSString *const ALL_USER_FIELDS = @"id,first_name,last_name,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,online,online_mobile,lists,domain,has_mobile,contacts,connections,site,education,universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,status,last_seen,common_count,relation,relatives,counters";


-(VKUsersArray*) loadUsers {
    __block VKUsersArray *users;
    VKRequest *request = [[VKApi friends] get:@{ @"user_id" : @1 }];
    request.waitUntilDone = YES;
    [request executeWithResultBlock:^(VKResponse *response)
     {
         users = response.parsedModel;
     }
      errorBlock:^(NSError *error)
     {
         
     }];
    return users;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"API_CALL"]) {
		ApiCallViewController *vc = [segue destinationViewController];
		vc.callingRequest = self->callingRequest;
		self->callingRequest = nil;
	}
}

- (void)callMethod:(VKRequest *)method {
	self->callingRequest = method;
	[self performSegueWithIdentifier:@"API_CALL" sender:self];
}

- (void)testCaptcha {
	VKRequest *request = [[VKApiCaptcha new] force];
	[request executeWithResultBlock: ^(VKResponse *response) {
	    NSLog(@"Result: %@", response);
	} errorBlock: ^(NSError *error) {
	    NSLog(@"Error: %@", error);
	}];
}

- (void)uploadPhoto {
    VKRequest *request = [VKApi uploadWallPhotoRequest:[UIImage imageNamed:@"apple"] parameters:[VKImageParameters pngImage] userId:0 groupId:60479154];
    [request executeWithResultBlock: ^(VKResponse *response) {
        NSLog(@"Photo: %@", response.json);
        VKPhoto *photoInfo = [(VKPhotoArray*)response.parsedModel objectAtIndex:0];
        NSString *photoAttachment = [NSString stringWithFormat:@"photo%@_%@", photoInfo.owner_id, photoInfo.id];
        VKRequest *post = [[VKApi wall] post:@{ VK_API_ATTACHMENTS : photoAttachment, VK_API_OWNER_ID : @"-60479154" }];
        [post executeWithResultBlock: ^(VKResponse *response) {
            NSLog(@"Result: %@", response);
            NSNumber * postId = response.json[@"post_id"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://vk.com/wall-60479154_%@", postId]]];
        } errorBlock: ^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } errorBlock: ^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)uploadPhotos {
	VKRequest *request1 = [VKApi uploadWallPhotoRequest:[UIImage imageNamed:@"apple"] parameters:[VKImageParameters pngImage] userId:0 groupId:60479154];
	VKRequest *request2 = [VKApi uploadWallPhotoRequest:[UIImage imageNamed:@"apple"] parameters:[VKImageParameters pngImage] userId:0 groupId:60479154];
	VKRequest *request3 = [VKApi uploadWallPhotoRequest:[UIImage imageNamed:@"apple"] parameters:[VKImageParameters pngImage] userId:0 groupId:60479154];
	VKRequest *request4 = [VKApi uploadWallPhotoRequest:[UIImage imageNamed:@"apple"] parameters:[VKImageParameters pngImage] userId:0 groupId:60479154];
	VKBatchRequest *batch = [[VKBatchRequest alloc] initWithRequests:request1, request2, request3, request4, nil];
	[batch executeWithResultBlock: ^(NSArray *responses) {
	    NSLog(@"Photos: %@", responses);
	    NSMutableArray *photosAttachments = [NSMutableArray new];
	    for (VKResponse * resp in responses) {
	        VKPhoto *photoInfo = [(VKPhotoArray*)resp.parsedModel objectAtIndex:0];
	        [photosAttachments addObject:[NSString stringWithFormat:@"photo%@_%@", photoInfo.owner_id, photoInfo.id]];
		}
	    VKRequest *post = [[VKApi wall] post:@{ VK_API_ATTACHMENTS : [photosAttachments componentsJoinedByString:@","], VK_API_OWNER_ID : @"-60479154" }];
	    [post executeWithResultBlock: ^(VKResponse *response) {
	        NSLog(@"Result: %@", response);
            NSNumber * postId = response.json[@"post_id"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://vk.com/wall-60479154_%@", postId]]];
		} errorBlock: ^(NSError *error) {
	        NSLog(@"Error: %@", error);
		}];
	} errorBlock: ^(NSError *error) {
	    NSLog(@"Error: %@", error);
	}];
}

- (void)uploadInAlbum {
	VKRequest *request = [VKApi uploadAlbumPhotoRequest:[UIImage imageNamed:@"apple"] parameters:[VKImageParameters pngImage] albumId:181808365 groupId:60479154];
	[request executeWithResultBlock: ^(VKResponse *response) {
	    NSLog(@"Result: %@", response);
        VKPhoto * photo = [(VKPhotoArray*)response.parsedModel objectAtIndex:0];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://vk.com/photo-60479154_%@", photo.id]]];
	} errorBlock: ^(NSError *error) {
	    NSLog(@"Error: %@", error);
	}];
}
- (void) logout:(id) sender {
    [VKSdk forceLogout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
