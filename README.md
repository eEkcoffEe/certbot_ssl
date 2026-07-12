```markdown
# Certbot SSL Setup Script

Автоматическая установка и настройка SSL-сертификата Let's Encrypt для сервера через Certbot.

Скрипт предназначен для VPS с публичным IP и доменом DuckDNS.

## Возможности

Скрипт автоматически:

- проверяет DNS-запись домена;
- устанавливает Certbot;
- получает SSL-сертификат Let's Encrypt;
- включает автоматическое продление сертификата;
- проверяет успешность обновления;
- выводит пути к сертификатам.

---

# Требования

Перед запуском необходимо:

- VPS сервер с Linux (Ubuntu/Debian);
- root-доступ;
- установленный домен;
- DNS A-запись, указывающая на IP сервера;
- открытый TCP порт 80.

Пример:

```

Домен:
sub-portal.free.com

IP:
157.157.157.157

````

Проверка:

```bash
ping sub-portal.free.com
````

Ожидаемый результат:

```
PING sub-portal.free.com (157.157.157.157)
```

---

# Установка

Скачать скрипт:

```bash
wget https://example.com/setup_ssl.sh
```

или создать вручную:

```bash
nano setup_ssl.sh
```

Сделать исполняемым:

```bash
chmod +x setup_ssl.sh
```

---

# Настройка

Перед запуском необходимо изменить параметры в файле:

```bash
nano setup_ssl.sh
```

Изменить:

```bash
DOMAIN="sub-portal.free.com"

EMAIL="localhost@gmail.com"

SERVER_IP="157.157.157.157"
```

Где:

| Параметр  | Описание                     |
| --------- | ---------------------------- |
| DOMAIN    | Домен для сертификата        |
| EMAIL     | Email аккаунта Let's Encrypt |
| SERVER_IP | IP адрес VPS                 |

---

# Запуск

Запускать от root:

```bash
sudo ./setup_ssl.sh
```

или:

```bash
sudo bash setup_ssl.sh
```

---

# Что делает скрипт

## 1. Проверка DNS

Проверяется, что домен указывает на сервер:

```
sub-portal.free.com
        |
        v
157.157.157.157
```

Если IP не совпадает — выполнение прекращается.

---

## 2. Установка Certbot

Устанавливается:

```bash
apt install certbot
```

---

## 3. Выпуск сертификата

Используется:

```bash
certbot certonly --standalone
```

После успешного выполнения:

Сертификат:

```
/etc/letsencrypt/live/sub-portal.free.com/fullchain.pem
```

Приватный ключ:

```
/etc/letsencrypt/live/sub-portal.free.com/privkey.pem
```

---

## 4. Автоматическое продление

Включается systemd timer:

```bash
systemctl enable --now certbot.timer
```

Проверить:

```bash
systemctl status certbot.timer
```

Ожидаемый статус:

```
Active: active (waiting)
```

---

## 5. Проверка обновления

Запускается:

```bash
certbot renew --dry-run
```

Успешный результат:

```
Congratulations, all simulated renewals succeeded
```

---

# Использование сертификата

## Nginx

Пример:

```nginx
server {

    listen 443 ssl;

    server_name sub-portal.free.com;


    ssl_certificate
    /etc/letsencrypt/live/sub-portal.free.com/fullchain.pem;


    ssl_certificate_key
    /etc/letsencrypt/live/sub-portal.free.com/privkey.pem;


}
```

После изменения:

```bash
nginx -t
```

Перезагрузка:

```bash
systemctl reload nginx
```

---

# Проверка сертификата

Информация о сертификате:

```bash
certbot certificates
```

Проверка дат:

```bash
openssl x509 \
-in /etc/letsencrypt/live/sub-portal.free.com/fullchain.pem \
-noout \
-dates
```

---

# Автопродление

Let's Encrypt выдает сертификаты сроком на:

```
90 дней
```

Certbot автоматически:

* проверяет сертификаты два раза в день;
* обновляет их примерно за 30 дней до окончания;
* сохраняет новые файлы автоматически.

Проверить расписание:

```bash
systemctl list-timers | grep certbot
```

---

# Структура проекта

```
.
├── README.md
└── setup_ssl.sh
```

---

# Пример результата

После выполнения:

```
=================================
 SSL Setup completed
=================================

Domain:
sub-portal.free.com

Certificate:
/etc/letsencrypt/live/sub-portal.free.com/fullchain.pem

Private key:
/etc/letsencrypt/live/sub-portal.free.com/privkey.pem

Renew:
Enabled
```

---

# Поддерживаемые системы

Проверено:

* Ubuntu 22.04
* Ubuntu 24.04
* Debian 11+

```

Можно положить рядом:

```

ssl-certbot/
├── README.md
└── setup_ssl.sh

```


