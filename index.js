console.log("Hello World!")
const oracledb = require('oracledb');

const dbConfig = {
    user: 'your_username',
    password: 'your_password',
    connectString: 'your_connection_string',
};

async function run() {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        // Your database operations go here

    } catch (err) {
        console.error(err);
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error(err);
            }
        }
    }
}

run().then(r => console.log("Connection closed."));
