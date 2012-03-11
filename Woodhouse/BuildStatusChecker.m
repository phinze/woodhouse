#import "BuildStatusChecker.h"
#import "Build.h"
#import "Notifications.h"
#import "WoodhouseKeychain.h"

#define DEFAULT_BUILD_UPDATE_DELAY_SECONDS 90.0

@interface BuildStatusChecker ()
- (Build *)buildFromPreviousRun:(Build *)currentBuild;
- (NSArray *)buildsThatJust:(SEL)statusSelector;
- (void)updateBuilds:(NSTimer*)theTimer;
- (void)scheduleNextCheck;
- (NSError *)parseResponseData;
- (void)notifyOfError:(NSError*)error;
- (void)makeRequest:(NSString*)url;
- (double)buildDelaySeconds;
- (void)watchForImmediateUpdateRequest;
@end

@implementation BuildStatusChecker

@synthesize builds;

- (id)init {
  if (self = [super init]){
    [self updateBuilds:nil];
    [self watchForImmediateUpdateRequest];
    runCount = 0;
  }
  return self;
}

- (BOOL)isFirstRun {
  return runCount <= 1;
}

- (void)updateBuilds:(NSTimer*)theTimer {
  [timer invalidate];
  responseData = [NSMutableData data];

  NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"Jenkins URL"];
  [self makeRequest:url];
}

- (void) makeRequest:(NSString*)url {
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) scheduleNextCheck {
  double seconds = [self buildDelaySeconds];
  timer = [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(updateBuilds:) userInfo:nil repeats:NO];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (double) buildDelaySeconds {
  NSString *delayFromPreferences = [[NSUserDefaults standardUserDefaults] objectForKey:@"Build Update Delay"];
  return ([delayFromPreferences length] == 0) ? DEFAULT_BUILD_UPDATE_DELAY_SECONDS : [delayFromPreferences floatValue];
}

# pragma mark build diff methods

- (NSArray *)buildsThatJustAppeared {
  return [self buildsThatJust:@selector(isPresent)];
}

- (NSArray *)buildsThatJustFailed {
  return [self buildsThatJust:@selector(isFailure)];
}

- (NSArray *)buildsThatJustSucceeded {
  return [self buildsThatJust:@selector(isSuccess)];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (NSArray *)buildsThatJust:(SEL)statusSelector {
  return [builds objectsAtIndexes: [builds indexesOfObjectsPassingTest:
           ^BOOL(id obj, NSUInteger _idx, BOOL *_stop) {
             Build *build = (Build *)obj;
             BOOL matchesStatus = (BOOL)[build performSelector:statusSelector];
             Build *previousBuild = [self buildFromPreviousRun:build];
             BOOL statusChanged = !(BOOL)[previousBuild performSelector:statusSelector];
             return matchesStatus && statusChanged;
           }
         ]];
}
#pragma clang diagnostic pop

- (Build *)buildFromPreviousRun:(Build *)currentBuild {
  for (Build *oldBuild in oldBuilds) {
    if ([oldBuild isEqual: currentBuild]) {
      return oldBuild;
    }
  }
  return nil;
}

#pragma mark connection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  if ([challenge previousFailureCount] == 0) {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"Jenkins Username"];
    NSString *password = [[WoodhouseKeychain sharedKeychain] getKeychainPasswordForUsername:nil];
    NSURLCredential *newCredential;
    newCredential = [NSURLCredential credentialWithUser:username
                                               password:password
                                            persistence:NSURLCredentialPersistenceNone];
    [[challenge sender] useCredential:newCredential
           forAuthenticationChallenge:challenge];
  } else {
    [[challenge sender] cancelAuthenticationChallenge:challenge];
    NSDictionary *errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Check your username and password in the preferences.", NSLocalizedDescriptionKey, nil];
    [self notifyOfError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserAuthenticationRequired userInfo:errorDict]];
  }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  if (![error code] == NSURLErrorUserCancelledAuthentication) {
    [self notifyOfError:error];
  }
  [self scheduleNextCheck];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSError *parsingError = [self parseResponseData];
  if (parsingError) {
    [self notifyOfError:parsingError];
  } else {
    runCount++;
    [[NSNotificationCenter defaultCenter] postNotificationName:BUILDS_UPDATED object:self];
  }
  [self scheduleNextCheck];
}

- (NSError *) parseResponseData {
  NSError *error;

  NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:responseData options:NSXMLDocumentTidyXML error:&error];
  if (error) {return error;}

  NSString *xpathQueryString = @"//Projects/Project";
  NSArray *newItemsNodes = [[document rootElement] nodesForXPath:xpathQueryString error:&error];
  if (error) {return error;}

  oldBuilds = builds;
  builds = [[NSMutableArray alloc] init];
  for (NSXMLElement *node in newItemsNodes) {
    [builds addObject:[[Build alloc] initFromNode:node]];
  }
  return nil;
}

- (void)notifyOfError:(NSError *)error {
  [[NSNotificationCenter defaultCenter] postNotificationName:BUILDS_FAILED_TO_UPDATE object:error];
}

- (void) watchForImmediateUpdateRequest {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBuilds:) name:CHECK_BUILDS_NOW object:nil];
}

@end
