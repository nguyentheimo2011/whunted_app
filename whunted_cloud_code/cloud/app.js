
express = require('express');
app = express();



app.set('views', 'cloud/views');  
app.set('view engine', 'ejs');    
app.use(express.bodyParser());    

app.get('/', function(req, res) {
  res.render('index', {});
});

app.post('/forgotPassword', function(req, res) {
	// res.send({'email': req.body.email});
	Parse.User.logIn(username, password, {
      success: function(user) {
         res.send('success');
      },
      error: function(user, error) {
        res.send('failure');
      }
   });
});

app.listen();
