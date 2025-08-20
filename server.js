const express = require('express');
const app = express();
app.get('/', (_, res) => res.send('Hello from RxLab DevSecOps!'));
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`App listening on ${port}`));
