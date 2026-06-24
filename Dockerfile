# استفاده از نسخه سبک اوبونتو
FROM ubuntu:22.04

# نصب پیش‌نیازها
RUN apt-get update && apt-get install -y wget unzip \
    && wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip Xray-linux-64.zip -d /usr/local/bin/ \
    && rm Xray-linux-64.zip \
    && apt-get clean

# ساختن فایل کانفیگ به صورت خودکار در لحظه بیلد
RUN echo '{ \
    "inbounds": [{ \
        "port": 8080, \
        "listen": "0.0.0.0", \
        "protocol": "vless", \
        "settings": { \
            "clients": [{"id": "83a24f02-3d51-42a6-86b7-2ecebfbe81bd"}], \
            "decryption": "none" \
        }, \
        "streamSettings": { \
            "network": "ws", \
            "wsSettings": {"path": "/"} \
        } \
    }], \
    "outbounds": [{"protocol": "freedom"}] \
}' > /etc/xray/config.json

# تعیین پورت خروجی
ENV PORT=8080

# اجرای Xray
CMD ["xray", "run", "-c", "/etc/xray/config.json"]
