const express = require('express');

const app = express();

app.get('/healthcheck', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

app.get('/', (req, res) => {
  res.status(200).json({ message: 'Hello World' });
});

app.listen(8080, () => {
  console.log('Listening on port 8080');
});
