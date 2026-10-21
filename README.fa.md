<div dir="rtl" align="right">

[English](README.md) | [فارسی](README.fa.md)

# کریپتو بازار (Crypto Bazzar)

![Flutter](https://img.shields.io/badge/Flutter-SDK-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12%2B-0175C2?logo=dart&logoColor=white)
[![مجوز MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE)

یک اپ کوچک Flutter برای دیدن قیمت ارزهای دیجیتال، با ظاهر تیره، برچسب‌های فارسی، جست‌وجوی نام ارز و تازه‌سازی با کشیدن لیست به پایین.

**وضعیت فعلی:** صفحه‌ها و تبدیل داده‌های API به مدل پیاده‌سازی شده‌اند، اما در هر دو درخواست HTTP، عبارت `API key` هنوز به‌عنوان آدرس موقت قرار دارد. قبل از اجرای اپ باید یک API سازگار برای داده‌های بازار تنظیم کنید؛ پروژه بدون این تنظیم قیمت‌ها را دریافت نمی‌کند.

## تصاویر برنامه

تصاویر زیر صفحه اسپلش، لیست ارزها، جست‌وجوی نام و حالت‌های به‌روزرسانی داده‌ها را نشان می‌دهند. فایل‌های اصلی در `assets/screenshots/` قرار دارند.

| صفحه اسپلش | لیست ارزها | جست‌وجوی نام |
| :---: | :---: | :---: |
| <img src="assets/screenshots/splash-screen.png" width="200" alt="صفحه اسپلش کریپتو بازار با لوگو و انیمیشن بارگذاری"/> | <img src="assets/screenshots/coinlist-screen(1).png" width="200" alt="لیست ارزها با قیمت و تغییرات ۲۴ساعته"/> | <img src="assets/screenshots/search-section.png" width="200" alt="نتایج جست‌وجوی نام ارز برای عبارت bit"/> |

| ادامه لیست ارزها | در حال به‌روزرسانی داده‌ها | تازه‌سازی با کشیدن لیست |
| :---: | :---: | :---: |
| <img src="assets/screenshots/coinlist-screen(2).png" width="200" alt="لیست اسکرول‌شده با ارزهای دارای رتبه پایین‌تر"/> | <img src="assets/screenshots/update-coinlist(1).png" width="200" alt="لیست ارزها همراه با پیام به‌روزرسانی اطلاعات"/> | <img src="assets/screenshots/update-coinlist(2).png" width="200" alt="لیست ارزها هنگام Pull-to-refresh با نشانگر بارگذاری"/> |

این تصاویر فقط برای مستندات هستند و لازم نیست به فهرست assetهای Flutter در `pubspec.yaml` اضافه شوند.

## قابلیت‌های اصلی

بعد از تنظیم درخواست‌های API، برنامه این امکانات را دارد:

- نمایش لوگو و انیمیشن بارگذاری `SpinKitWave` در صفحه اسپلش، تا دریافت اولیه داده‌های بازار.
- نمایش نام، نماد، رتبه، قیمت دلاری و درصد تغییرات ۲۴ساعته هر ارز در یک لیست قابل اسکرول.
- نمایش قیمت و درصد تغییر با دو رقم اعشار، همراه با رنگ و آیکن سبز/صعودی یا قرمز/نزولی برای تغییر قیمت.
- جست‌وجوی نام ارز بدون حساسیت به حروف بزرگ و کوچک.
- دریافت دوباره لیست ارزها با Pull-to-refresh.
- رنگ‌بندی تیره، برچسب‌های فارسی، کادر جست‌وجوی RTL و فونت‌های سفارشی همراه پروژه.

این اپ برای نمایش لیست بازار است، نه انجام معامله. نمودار، صفحه جزئیات ارز، علاقه‌مندی‌ها، سبد دارایی و ذخیره‌سازی آفلاین پیاده‌سازی نشده‌اند. مدل مقدار ارزش بازار را هم دریافت می‌کند، اما این مقدار در لیست نمایش داده نمی‌شود.

## ابزارها و معماری

ساختار پروژه ساده و مبتنی بر صفحه‌هاست؛ از Clean Architecture یا MVVM استفاده نمی‌کند. در حال حاضر، درخواست‌های شبکه و وضعیت رابط کاربری داخل ویجت‌های صفحه قرار دارند و مدل داده و ثابت‌های رنگ در فایل‌های جدا نگهداری می‌شوند.

<div dir="ltr" align="left">

```text
lib/
├── main.dart                    # Application entry point and MaterialApp
├── data/
│   ├── constant/
│   │   └── constants.dart       # Shared colors
│   └── model/
│       └── crypto.dart          # Crypto model and JSON parsing
└── screens/
    ├── splash_screen.dart      # Initial request, loading UI, and navigation
    └── coin_list_screen.dart   # Coin rows, search, and refresh
```

</div>

در این ساختار، `main.dart` نقطه شروع برنامه است، `constants.dart` رنگ‌های مشترک را نگه می‌دارد و `crypto.dart` مسئول مدل و تبدیل JSON است. `splash_screen.dart` دریافت اولیه، بارگذاری و جابه‌جایی بین صفحه‌ها را انجام می‌دهد و `coin_list_screen.dart` لیست، جست‌وجو و تازه‌سازی را مدیریت می‌کند.

**State Management:** از `StatefulWidget`، `initState` و `setState` استفاده شده است. پروژه BLoC، Provider، Riverpod، لایه Repository یا دیتابیس محلی ندارد.

**جریان داده:** فایل `main.dart` صفحه `SplashScreen` را باز می‌کند. این صفحه پاسخ API را می‌گیرد، آرایه `response.data['data']` را به مدل‌های `Crypto` تبدیل می‌کند و لیست را به `CoinListScreen` می‌دهد. صفحه لیست برای تازه‌سازی و هنگام پاک شدن عبارت جست‌وجو درخواست جداگانه می‌فرستد. تبدیل JSON به‌صورت دستی در `Crypto.fromMapJson` نوشته شده و مدل‌ها با Code Generation ساخته نشده‌اند.

### پکیج‌ها

وابستگی‌های مستقیم تعریف‌شده در `pubspec.yaml`:

- **Flutter SDK** — ویجت‌های Material، مسیریابی و مدیریت وضعیت داخلی Flutter.
- **`dio: ^5.11.1`** — ارسال درخواست HTTP برای دریافت داده‌های بازار.
- **`flutter_spinkit: ^5.2.2`** — انیمیشن بارگذاری صفحه اسپلش.
- **`cupertino_icons: ^1.0.8`** — وابستگی آیکن‌های Cupertino.

وابستگی‌های توسعه:

- **`flutter_test`** — ابزار تست Flutter.
- **`flutter_lints: ^6.0.0`** — قواعد lint که در `analysis_options.yaml` فعال شده‌اند.

فایل‌های همراه پروژه شامل `assets/images/logo.png` و خانواده‌های فونت `mr` و `iranYekan` هستند. فایل‌های این فونت‌ها به‌ترتیب `assets/fonts/mh.ttf` و `assets/fonts/iyl.ttf` هستند. صفحه‌ها در حال حاضر از خانواده `mr` استفاده می‌کنند.

### مشخصات پروژه

- نام پکیج: `crypto_bazzar`.
- نسخه: `1.0.0+1`.
- توضیح فعلی در manifest: `A new Flutter project.`؛ هنوز همان توضیح اولیه Flutter است.
- محدودیت Dart SDK: `^3.12.0`؛ یعنی **نسخه 3.12.0 یا بالاتر و پایین‌تر از 4.0.0**.
- مقدار `publish_to: 'none'` انتشار پکیج را غیرفعال می‌کند.
- پوشه‌های اجرای Android، iOS، وب، Windows، macOS و Linux وجود دارند؛ وجود این پوشه‌ها به معنی تست شدن اپ روی همه این پلتفرم‌ها نیست.

## شروع کار

### ۱. آماده کردن محیط

یک Flutter SDK نصب کنید که Dart نسخه 3.12.0 یا بالاتر، در محدوده گفته‌شده، همراه آن باشد. ابزارهای لازم برای پلتفرم هدف را هم نصب کنید و یک شبیه‌ساز Android، دستگاه متصل یا هدف دیگری از Flutter آماده داشته باشید.

<div dir="ltr" align="left">

```bash
flutter --version
flutter doctor
```

</div>

در lockfile یک حداقل نسخه برای Flutter ثبت شده، اما نسخه Flutter انتخابی باید محدودیت Dart پروژه را هم پوشش بدهد. در `pubspec.yaml` نسخه دقیق Flutter SDK پین نشده است.

### ۲. کلون کردن مخزن

<div dir="ltr" align="left">

```bash
git clone https://github.com/mehrshadkhv/crypto-bazzar.git
cd crypto-bazzar
```

</div>

اگر پروژه را از قبل روی سیستم دارید، وارد همان پوشه محلی شوید.

### ۳. نصب وابستگی‌ها

<div dir="ltr" align="left">

```bash
flutter pub get
```

</div>

پروژه وابستگی `build_runner`، `freezed` یا `json_serializable` ندارد؛ بنابراین نیازی به اجرای دستور Code Generation برای کد برنامه نیست.

### ۴. تنظیم درخواست‌های داده بازار

عبارت موقت `API key` را که به `Dio().get(...)` داده شده، در **هر دو محل** جایگزین کنید:

- `lib/screens/splash_screen.dart` — متد `getData()`.
- `lib/screens/coin_list_screen.dart` — متد `_getData()`.

کامنت‌های کد به CoinCap اشاره می‌کنند، اما آدرس قابل استفاده یا احراز هویت تنظیم نشده است. یک endpoint معتبر از سرویس انتخابی خود بگیرید و روش احراز هویت فعلی همان سرویس را رعایت کنید. توکن API، آدرس URL نیست: آدرس endpoint را در URL درخواست قرار دهید و در صورت نیاز، احراز هویت را جداگانه با تنظیمات درخواست Dio انجام دهید. توکن‌های خصوصی را در Git کامیت نکنید.

پارسر فعلی یک آبجکت JSON با آرایه `data` انتظار دارد. هر عضو باید شامل `id`، `name`، `symbol`، `rank`، `priceUsd`، `changePercent24Hr` و `marketCapUsd` باشد. فیلدهای عددی از مقدارهای رشته‌ای تبدیل می‌شوند. نام کلیدها، از جمله حروف بزرگ و کوچک `changePercent24Hr`، باید دقیقاً همین باشد. اگر سرویس شما نام، نوع یا ساختار دیگری برمی‌گرداند، `Crypto.fromMapJson` و تبدیل پاسخ در هر دو صفحه را تغییر دهید.

برنامه به اینترنت نیاز دارد و داده آزمایشی یا حالت آفلاین ندارد.

### ۵. اجرای برنامه

<div dir="ltr" align="left">

```bash
flutter devices
flutter run
```

</div>

برای انتخاب یک دستگاه مشخص:

<div dir="ltr" align="left">

```bash
flutter run -d <device-id>
```

</div>

### تنظیمات پلتفرم پیش از انتشار

- **Android:** مجوز `INTERNET` در manifest اصلی وجود ندارد و فعلاً فقط در manifestهای debug/profile تعریف شده است. برای دسترسی به شبکه در نسخه release، خط زیر را در `android/app/src/main/AndroidManifest.xml`، مستقیماً زیر عنصر ریشه `manifest` و بیرون از `application` قرار دهید:

<div dir="ltr" align="left">

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

</div>

  شناسه برنامه هنوز `com.example.crypto_bazzar` است و نسخه release با کلید debug امضا می‌شود. قبل از توزیع، شناسه و امضای مناسب release را تنظیم کنید. فایل‌های build اندروید از Java/Kotlin 17 استفاده می‌کنند.

- **macOS:** فایل‌های entitlement مربوط به sandbox، کلید `com.apple.security.network.client` را ندارند. برای ارسال درخواست به API، تنظیمات entitlement در debug/profile و release را بررسی کنید.
- **وب:** API باید از طریق CORS به درخواست‌های مبدأ مرورگر برنامه اجازه بدهد.
- **iOS و دسکتاپ:** ابزارهای Flutter مخصوص پلتفرم هدف را آماده کنید و رفتار برنامه را روی همان پلتفرم بررسی کنید؛ فایل‌های اولیه runner به‌تنهایی تضمین پشتیبانی نیستند.

## بررسی‌ها و محدودیت‌های فعلی

برای تحلیل ایستای کد:

<div dir="ltr" align="left">

```bash
flutter analyze
```

</div>

فایل `test/widget_test.dart` هنوز تست شمارنده اولیه Flutter است و به‌جای صفحه‌های ارز، متن‌های `0` و `1` و دکمه اضافه کردن را انتظار دارد. قبل از اتکا به مجموعه تست، آن را با تست‌های مرتبط با اپ جایگزین یا اصلاح کنید. دستور اجرای تست‌ها:

<div dir="ltr" align="left">

```bash
flutter test
```

</div>

چند محدودیت دیگر که برای توسعه پروژه باید در نظر بگیرید:

- برای خطای API یا پاسخ نامعتبر، صفحه خطا و مسیر تلاش دوباره وجود ندارد؛ خطای درخواست اولیه ممکن است برنامه را در صفحه بارگذاری نگه دارد.
- جست‌وجو روی لیست فعلی انجام می‌شود، نه یک نسخه جدا از داده اصلی. پاک کردن عبارت جست‌وجو داده‌ها را دوباره دریافت می‌کند؛ بنابراین کوتاه‌تر کردن یک عبارت غیرخالی ممکن است ارزهای قبلاً حذف‌شده از نتیجه را برنگرداند.
- درخواست‌های async بررسی `mounted` یا لغو درخواست ندارند.
- صفحه‌بندی، مرتب‌سازی سفارشی و کش ماندگار پیاده‌سازی نشده‌اند.

## مجوز استفاده

این پروژه تحت [مجوز MIT](LICENSE) منتشر شده است.

</div>
