const express = require('express');

const PORT = 8080;
const app = express();

app.get('/healthcheck', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

app.get('/', (req, res) => {
  res.status(200).json({ message: 'Hello World' });
});

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});
