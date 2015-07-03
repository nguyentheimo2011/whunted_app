//
// Copyright (c) 2015 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>

#import "JSQMessages.h"
#import "RNGridMenu.h"

//-------------------------------------------------------------------------------------------------------------------------------
@interface ChatView : JSQMessagesViewController <RNGridMenuDelegate, UIImagePickerControllerDelegate>
//-------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong) NSString *user2Username;
@property (nonatomic, strong) NSString *buyerID;
@property (nonatomic, strong) NSString *sellerID;
@property (nonatomic, strong) NSString *itemID;

- (id)initWith:(NSString *)groupId_;

@end
