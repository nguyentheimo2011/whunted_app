
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var twilio = require('twilio')('AC472c358bd2d70853d1b84e2848cd5a71', '4494f3e24a1c4e05a0f20733727f4ebc');

Parse.Cloud.define("sendVerificationCode", function(request, response) {
    var verificationCode = Math.floor(Math.random()*999999);
    var user = Parse.User.current();
    user.set("phoneVerificationCode", verificationCode);
    user.save();
    
    twilio.sendSms({
        From: "+1 616-710-4599",
        To: request.params.phoneNumber,
        Body: "Your verification code is " + verificationCode + "."
    }, function(err, responseData) { 
        if (err) {
          response.error(err);
        } else { 
          response.success("Success");
        }
    });
});

Parse.Cloud.define("verifyPhoneNumber", function(request, response) {
    var user = Parse.User.current();
    var verificationCode = user.get("phoneVerificationCode");
    if (verificationCode == request.params.phoneVerificationCode) {
        user.set("phoneNumber", request.params.phoneNumber);
        user.save();
        response.success("Success");
    } else {
        response.error("Invalid verification code.");
    }
});