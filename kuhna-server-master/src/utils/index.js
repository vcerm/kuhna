import mysql from 'mysql2/promise';

const getConnection = async () => {
    return await mysql.createConnection({
        host: 'localhost',
        port: 3306,
        database: 'kuhna',
        user: 'root',
        password: '',
    });
};

export {
    getConnection,
};