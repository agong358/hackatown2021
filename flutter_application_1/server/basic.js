const fs = require('fs');
const {Pool} = require('pg');

//Connect to the database.
const pool = new Pool({
    user: 'nhien',
    password: 'NhienCockroach',
    host: 'free-tier.gcp-us-central1.cockroachlabs.cloud',
    database: 'thorny-coyote-522.food',
    port: 26257,
    ssl: {
        ca: fs.readFileSync('./certs/ca.crt').toString()
    }
});

const addIngredient = (request, response) => {
    //const name = request.body.name;
    pool.query(`INSERT INTO food.ingredients VALUES ('${request.body.name}');`, (error, results) => {
        if (error) {
            response.json(-1);
            throw error;
        }
        response.status(201).json(results.rows)
    })
}

const getIngredients = (request, response) => {
    pool.query('SELECT * FROM food.ingredients;', (error, results) => {
        if (error) {
            throw error
        }
        response.status(200).json(results.rows)
    })
}

const deleteIngredient = (request, response) => {
    pool.query(`DELETE FROM food.ingredients WHERE name = '${request.body.name}';`, (error, results) => {
        if (error) {
            response.json(-1);
            throw error;
        }
        response.status(200).json(results.rows)
    })
}





module.exports = {
    getIngredients,
    addIngredient,
    deleteIngredient
}