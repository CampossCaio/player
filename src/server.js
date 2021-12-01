const express = require('express');
const multer = require ('multer');
const uploadConfig = require('./config/upload.js');
const path = require('path');
const fs = require('fs');
const { exec, spawn } = require('child_process');
const cors = require('cors');

let filePath = path.resolve('./src/videos');
const scriptPath = path.resolve('./teste.sh');
let mediaCode;

const app = express();
app.use(cors());
const upload = multer(uploadConfig);

app.use(cors());

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '..', './public/index.html'));
});

app.get('/opa', (req, res) => {
  res.send('opa!');
});

app.get('/videos/:mediaCode', async (req, res) => {
  const { mediaCode: code } = req.params;
  res.setHeader('Access-Control-Allow-Origin', '*');

  mediaCode = code;
  
  fs.readFile(`${filePath}/${mediaCode}/master.m3u8`, function(error, content) {

    if (error) {
      return console.error(error);
    }
    
    res.end(content, 'utf-8');
  });
});

app.get('/videos/:resolution/:id', async (req, res) => {
 
  const { resolution, id } =  req.params;

  res.setHeader('Access-Control-Allow-Origin', '*');
  fs.readFile(`${filePath}/${mediaCode}/${resolution}/${id}`, function(error, content) {

    if (error) {
      return console.error(error);
    }
    
    res.end(content, 'utf-8');
  });
});

// app.get('/subtitle/:id', async (req, res) => {
 
//   const { id } =  req.params;

//   res.setHeader('Access-Control-Allow-Origin', '*');
//   fs.readFile(`${filePath}/subtitle/${id}`, function(error, content) {

//     if (error) {
//       return console.error(error);
//     }
    
//     res.end(content, 'utf-8');
//   });
// });

app.post('/videos',upload.single('video'), async (req, res) => {
  const { filename } = req.file;

  exec(`bash ${scriptPath} ${filename} `, (err, stdout, stderr) => {
    if (err) {
      console.error(err);
      return;
    }
    console.log('Deu bom!');
  });

  const mediaCode = filename.split('.')[0];

  return res.json(mediaCode);
});


app.listen(process.env.PORT || 3333, () => console.log('Server is running at 3333'));