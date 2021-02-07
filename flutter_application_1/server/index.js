const express = require('express')
const bodyParser = require('body-parser')
const db = require('./basic.js')
const port = 8080
const app = express()
const cors = require('cors')

app.use(cors())
app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)

app.get('/ingredients', db.getIngredients)

app.get('/', (request, response) => {
    response.json({info: 'HELLO WOLRD'})
})

app.post('/add-ingredient', db.addIngredient)

app.post('/delete-ingredient', db.deleteIngredient)

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})