const express = require('express');

const PORT = 8080;
const app = express();

app.use((req, res) => {
  console.log('Request received');
  console.log(JSON.stringify(req.path));
  res.status(200).json({ status: 'OK' });
});

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});
