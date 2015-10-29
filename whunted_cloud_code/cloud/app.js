
express = require('express');
app = express();

app.set('views', 'cloud/views');  
app.set('view engine', 'ejs');    
app.use(express.bodyParser());    

app.get('/', function(req, res) {
  res.render('index', {});
});

app.post('/forgotPassword', function(req, res) {
	res.send({success:true});
});

app.listen();
