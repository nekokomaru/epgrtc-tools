# Tools for EPGStation with RTC

### 概要
EPGStation を運用している Linux PC の起動制御を行うためのツール群

### 目的
EPGStation を運用している PC を、録画及びエンコード終了時には停止、録画開始前に起動して、駆動時間をなるべく少なくする。これにより HDD 動作時間、動作音、消費電力等を低減する

### 動作環境
作者が動作させている環境は以下の通り
* ハードウェア
  * raspberryPi 4B
  * [RTC board For RaspberryPI 1.0](https://nekokohouse.sakura.ne.jp/raspi/#rasp_rtc)
* ソフトウェア
  * Ubuntu Server 20.04.2 LTS 64bit
  * [Mirakurun 3.5.0](https://github.com/Chinachu/Mirakurun)
  * [EPGStation 2.0.10](https://github.com/l3tnun/EPGStation) APIが変更される前の古いバージョンでは動作しない
  * [PCF2127 driver with alarm function for kernel 5.4](https://github.com/nekokomaru/pcf2127mod)

### 大まかな動作
* PC の起動制御には RTC のアラーム機能を使う。具体的には rtcwake コマンドを使用する
* EPGStation の API を使って予約情報、エンコード情報を取得し、現時点でシャットダウンすべきかどうかを判断する
* 同様に、取得した予約情報を用いて、シャットダウン時に RTC へアラーム時刻をセットする
* 録画終了時及びエンコード終了時にも、同様にしてシャットダウンするかどうかを判断を行う(ただし、エンコード終了時の処理には制限有りもしくは再ビルドが必要)
* EPG データを取得する時刻も指定可能であり、その時間を RTC へセットすることも行う

### 謝辞
スクリプトの作成には以下のサイトを参考にした。ありがとうございます  
<https://qiita.com/tsugulin/items/6faf135946b598b17f48>

### 免責事項
本ソフトウェアの動作は保証しない。著作権者は一切の責任を負わない

### ライセンス
MIT ライセンスである。詳しくは LICENSE を参照のこと

### 著作者
Yachiyo <https://nekokohouse.sakura.ne.jp/>
