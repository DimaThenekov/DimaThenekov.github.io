const http = require('http');
const url = require('url');

const port = 3000;

const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    const path = parsedUrl.pathname;
    const query = parsedUrl.query;

    // Устанавливаем заголовки CORS для простоты тестирования
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');

    // Маршрутизация
    if (path === '/' || path === '/home') {
        res.statusCode = 200;
        res.end('Привет! Сервер Node.js работает!\nПерейдите на /hello или /about\n');
    } else if (path === '/hello') {
        const name = query.name || 'Гость';
        res.statusCode = 200;
        res.end(`Привет, ${name}!\n`);
    } else if (path === '/about') {
        res.statusCode = 200;
        res.end('Это простой HTTP-сервер на Node.js\nВерсия: 1.0\n');
    } else if (path === '/status') {
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.end(JSON.stringify({
            status: 'ok',
            message: 'Сервер работает',
            timestamp: new Date().toISOString()
        }, null, 2));
    } else if (path === '/headers') {
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.end(JSON.stringify({
            headers: req.headers,
            method: req.method,
            url: req.url
        }, null, 2));
    } else {
        res.statusCode = 404;
        res.end('Страница не найдена\n');
    }
});

// Запускаем сервер
server.listen(port, () => {
    console.log(`✅ Сервер запущен на http://localhost:${port}`);
    console.log('📍 Доступные маршруты:');
    console.log('   http://localhost:3000/');
    console.log('   http://localhost:3000/hello');
    console.log('   http://localhost:3000/hello?name=Иван');
    console.log('   http://localhost:3000/about');
    console.log('   http://localhost:3000/status');
    console.log('   http://localhost:3000/headers');
    console.log('\n🛑 Нажмите Ctrl+C для остановки');
});

// Обработка ошибок
server.on('error', (error) => {
    if (error.code === 'EADDRINUSE') {
        console.error(`❌ Порт ${port} уже занят. Попробуйте другой порт.`);
        process.exit(1);
    } else {
        console.error('❌ Ошибка сервера:', error);
    }
});

// Корректное завершение
process.on('SIGINT', () => {
    console.log('\n🛑 Останавливаем сервер...');
    server.close(() => {
        console.log('✅ Сервер остановлен');
        process.exit(0);
    });
});
