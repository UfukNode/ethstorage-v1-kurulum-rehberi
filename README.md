# EthStorage Trusted Setup Ceremony - Otomatik Kurulum

Bu script, EthStorage v1 Trusted Setup Ceremony'e katılmak için gereken tüm kurulumları otomatik olarak yapar. Manuel kurulum derdi yok, birkaç komutla çalıştırabilirsiniz.

---

## Gereksinimler

### Sistem Gereksinimleri
- Ubuntu 22.04 / WSL ile de Çalıştırabilirsiniz.
- En az 2GB RAM.
- Gereksinimler düşük o yüzden sunuculara para harcamayın.

---

### Not:
Sunucu gerekmeden kurulum için arkadaşlar codespaces kullanabilir. Bunun için sunucuya girdiklerinde aşağıdaki komutları uygularlarsa sorunsuz kurulumu yapacaklardır. 

```bash
sudo su
cd ../../root/
```

### 1- Script'i çalıştır

```bash
wget https://raw.githubusercontent.com/UfukNode/ethstorage-v1-kurulum-rehberi/main/script.sh
```
```bash
chmod +x script.sh
sudo ./script.sh
```

---

### 2- GitHub gereksinimlerini kontrol et

Script sana GitHub hesap gereksinimlerini soracak:
- En az 1 aylık hesap var mı?
- En az 1 public repository var mı?  
- En az 5 kişiyi takip ediyor musun?
- En az 1 takipçin var mı?

Gereksinimleri karşılıyorsan bu soruya **y** cevabını ver.

<img width="388" height="123" alt="image" src="https://github.com/user-attachments/assets/8937c655-9d90-49f8-8db6-83240b7198e1" />

---

### 3- Sistem kurulumu bekle

Script otomatik olarak:
- Sistem paketlerini güncelleyecek.
- NVM kuracak.
- Node.js 18 kuracak.
- Phase2CLI kuracak.

Bu adımda hiçbir şey yapman gerekmiyor, bekle.

<img width="744" height="237" alt="image" src="https://github.com/user-attachments/assets/15e62efc-853f-4285-94ee-f92ae818a825" />

---

### 4- GitHub kimlik doğrulaması yap

Script "GitHub kimlik doğrulaması başlatılıyor" diyecek:
- Enter'a bas.
- Terminal'de bir kod gösterecek.
- Bu kodu kopyala.
- https://github.com/login/device adresine git.
- Kodu yapıştır.
- "Authorize ethstorage" butonuna tıkla.

![Adsız tasarım](https://github.com/user-attachments/assets/d760b8d7-44b5-4129-8892-51c93dc14019)

---

### 5- Ceremony başlatılması

Script "Ceremony başlatılıyor" deyince:
- Enter'a bas.
- Screen oturumu açılacak ve aşağıdaki komutla girmeniz gerekiyor.

```bash
screen -r ceremony
```

- Ceremony otomatik başlayacak.

---

### 6- Entropy seçimi yap

Ceremony başladığında sana soracak:
- **Randomly** için Enter'a bas
- **Manually** için istediğin karakterleri gir
- Random seçebilirsiniz, ben öyle yaptım.

![Adsız tasarım (1)](https://github.com/user-attachments/assets/a0cef741-fa37-456d-a8eb-50af8aba56ed)

---

### 7- Sırada bekle

Ceremony seni sıraya alacak:
- Kaç kişi önünde olduğunu gösterecek.
- Bekleme süresini gösterecek.
- Sabırla bekle. (saatlerce sürebilir)
- CTRL + a + d yapıp arka planda sıranın devam etmesi için bırakabilirsiniz.
- Sırayı kontrol etmek için "screen -r ceremony" komutunu kullanabilirsiniz.

<img width="600" height="126" alt="image" src="https://github.com/user-attachments/assets/ae612940-dbb6-4932-8529-c5ab26a7c3fc" />

---

## Screen Komutları

Ceremony arka planda screen oturumunda çalışır:

```bash
# Ceremony durumunu kontrol et
screen -r ceremony

# Screen'den çık (ceremony çalışmaya devam eder)
Ctrl+A+D

# Aktif screen'leri gör  
screen -ls
```

---

## Sorun Giderme

### Ceremony durursa eğer aşağıdaki komutları sırayla girmeniz yeterli olacaktır.

```bash
screen -r ceremony
```
```bash
cd ~/trusted-setup-tmp
```
```bash
phase2cli contribute -c ethstorage-v1-trusted-setup-ceremony
```

---

## Sosyal Medya

Ceremony tamamlandığında sosyal medyada paylaşın.

- Ekran görüntüsü al.
- İngilizce bir gönderi hazırla.
- Paylaşımını X'te Ethstorage'ı etikeleyerek paylaş
