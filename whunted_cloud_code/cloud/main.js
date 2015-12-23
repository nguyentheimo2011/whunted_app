
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var twilio = require('twilio')('AC472c358bd2d70853d1b84e2848cd5a71', '4494f3e24a1c4e05a0f20733727f4ebc');

Parse.Cloud.define("sendVerificationCode", function(request, response) 
{
	// Generate verification code
	var randNum = Math.random();
	if (randNum < 0.11)
		randNum += 0.11;

    var verificationCode = Math.floor(randNum * 999999);

    // Save verification code to database
    var user = Parse.User.current();
    user.set("phoneNumber", request.params.phoneNumber);
    user.set("phoneVerificationCode", verificationCode);
    user.save();

    // Based on user's phone language, send an sms message in that language.
    var message;
    var phoneLang = request.params.phoneLanguage; 
    if (phoneLang.localeCompare("zh-Hant") == 0)
    	message = "從Whunted傳送 - 手機認證碼為 " + verificationCode + ".";
    else
    	message = "Sent from Whunted - Your verification code is " + verificationCode + ".";
    
    twilio.sendSms(
    {
        From: "+1 616-710-4599",
        To: request.params.phoneNumber,
        Body: message
    }
    , function(err, responseData) 
    { 
        if (err) 
        {
          response.error(err);
        } 
        else 
        { 
          response.success("Success");
        }
    });
});

Parse.Cloud.define("verifyPhoneNumber", function(request, response) 
{
    var user = Parse.User.current();
    var verificationCode = user.get("phoneVerificationCode");
    if (verificationCode == request.params.phoneVerificationCode) 
    {
        user.set("phoneVerified", true);
        user.set("phoneVerificationCode", 0);
        user.save();
        response.success("Success");
    } 
    else 
    {
        response.error("Invalid verification code.");
    }
});

// Make sure that isDeleted is set to NO
Parse.Cloud.beforeSave("OngoingWantData", function(request, response) 
{
    if (!request.object.get("itemIsDeleted"))
        request.object.set("itemIsDeleted", "NO");
});


