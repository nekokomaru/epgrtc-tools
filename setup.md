# セットアップ手順


### インストール手順
1. コマンド `jq` をインストールする

```shell:cmd
sudo apt install jq
```

2. ファイルをクローンする

```shell:cmd
git clone https://github.com/nekokomaru/epgrtc-tools.git
```

3. epg 取得時刻を設定する。setalarm.conf ファイルを編集し、epg 取得時刻を 24時間表記で設定する。早い時刻（小さい値）から記述すること

```shell:cmd
cd epgrtc-tools/script
vi setalarm.conf   # デフォルトでは 6時、20時が設定されているので必要に応じて書き換える
```

4. スクリプトをインストールする。`/usr/local/bin` と `/usr/local/etc` に必要なファイルがインストールされ、ホームディレクトリの `.bash_aliases` に reboot のエイリアスが設定される

```shell:cmd
./install_script.sh install
```

5. サービスをインストールする。`/etc/systemd/system` に必要なファイルがインストールされ、サービスとして登録される

```shell:cmd
cd ../service/
./install_service.sh install
```

6. EPGStation の設定ファイルを書き換える。EPGStation を停止してから、設定ファイルの `config.yml` を書き換える。設定内容は、録画終了時の処理の追加である。
書き換え内容は `epgrtc-tools/epgconf/config.yml` にある一行の追加であり、コマンドで処理しようと思うなら例えば以下のようになるだろう  

```shell:cmd
sudo pm2 stop epgstation   # EPGStation を止める
cd [EPGStationのインストールディレクトリ]
cp config/config.yml config/config.yml.bak   # バックアップを取っておく
cat ~/epgrtc-tools/epgconf/config.yml >> config/config.yml
```

7. 続いて、エンコード終了時の処理を設定する。これには二通りあるので、以降からどちらか一方、好きな方を選ぶ

8. エンコード終了時設定方法、その1。エンコード設定ファイル `enc.js` を書き換える。これには制限があり、本来であればエンコードが終了すると録画済みファイルに TS ファイルと
エンコードしたファイルが登録されるが、この設定方法の場合は**エンコードしたファイルは登録されない**  
書き換え内容は `epgrtc-tools/epgconf/enc.js` の内容の追記である。コマンドで処理しようと思うなら例えば以下のようになるだろう。epgstation をリスタートしたらインストールは終了である

```shell:cmd
cp config/enc.js config/enc.js.bak  # バックアップを取っておく
cat ~/epgrtc-tools/epgconf/enc.js >> config/enc.js
sudo pm2 restart epgstation   # 設定が終わったのでリスタートする
```
9. エンコード終了時設定方法、その2。8. での制限を回避するため、EPGStation のソースコードを改変する。v2.0.10 であれば、インストールされている EPGStation のソースファイルを
`epgrtc-tools/epgsrc/EncodeFinishModel.ts` で上書きして置き換えれば良い  
ビルドしてサービスを登録したらインストール終了である

```shell:cmd
sudo pm2 delete epgstation   # 一旦削除する
sudo pm2 save
pwd  # 現在、EPGStation のインストールディレクトリにいるとする
cp src/model/service/encode/EncodeFinishModel.ts src/model/service/encode/EncodeFinishModel.ts.bak   # バックアップを取っておく
cp ~/epgrtc-tools/epgsrc/EncodeFinishModel.ts src/model/service/encode/   # パッチのあたったソースファイルで置き換える
npm run build   # ビルドする。完了を待つ
sudo pm2 start dist/index.js --name "epgstation"   # サービス登録
sudo pm2 save
```
---

### インストール手順 9. でのソースコード改変内容
ソースファイルの改変内容を説明しておく。v2.0.10 以外のバージョンへの適用については、以下の記述を参考にすれば良いだろう

##### 概要
エンコード処理が終わり、データベースへの登録などの後処理が一通り終わったタイミングで、シャットダウンコマンドを実行するようにソースコードを直接書き換える

##### 書き換え対象
主なエンコード終了処理が `src/model/service/encode/EncodeFinishModel.ts` 内の `finishEncode`関数で行われているので、ここを書き換える

##### 書き換え内容

* child process を生成するため、`EncodeFinishModel.ts` の冒頭で宣言を行う

```javascript:EncodeFinishModel.ts
import * as child_process from 'child_process';
import * as util from 'util';
const EXE_FILE: string = '/usr/local/bin/shutdown_srv';
const exec: any = util.promisify(child_process.exec);
```

* `finishEncode`関数の最後のあたり、`this.socket.notiFyClient()` の前に追記する    
ちなみに、下手にコメントを入れないほうがいいっぽいので、下記のコメントも入れないほうがいいと思う（eslint がエラーを出したりする）
```javascript:EncodeFinishModel.ts
        }
        await exec(EXE_FILE);    // <-これを追記する
        this.socket.notifyClient();
    }
```
---

### アンインストール手順

1. EPGStation の設定ファイルを戻す

```shell:cmd
sudo pm2 stop epgstation   # EPGStation を止める
cd [EPGStationのインストールディレクトリ]
cp config/config.yml.bak config/config.yml   # バックアップを戻す
```
```shell:cmd
# 8. の場合
cp config/enc.js.bak config/enc.js  # バックアップを戻す
sudo pm2 restart epgstation   # リスタートする
```
```shell:cmd
# 9. の場合
sudo pm2 delete epgstation   # 一旦削除する
sudo pm2 save
cp src/model/service/encode/EncodeFinishModel.ts.bak src/model/service/encode/EncodeFinishModel.ts   # バックアップで戻す
npm run build   # ビルドする。完了を待つ
sudo pm2 start dist/index.js --name "epgstation"   # サービス登録
sudo pm2 save
```

2. サービスをアンインストールする

```shell:cmd
cd ~/epgrtc-tools/service
./install_service.sh uninstall
```

3. スクリプトをアンインストールして完了

```shell:cmd
cd ../script
./install_script.sh uninstall
```
