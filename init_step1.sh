#!/bin/bash
# Step1

# このスクリプトはsshのセキュリティ設定、日本語ロケールのインストール、ユーザーの追加とグループの設定を行います。
# Step2のスクリプト init_step2.sh よりも先にこのスクリプト(init_step1.sh)を実行してください。

#-----------設定--------------------------------------

#-----sshd_configの変更----------------------
# 変更する項目を指定
# 入力例) oldConfigText1="設定ファイルの初期テキスト"
oldConfigText1="#PasswordAuthentication yes"
oldConfigText2="#PermitRootLogin prohibit-password"
# 変更後の設定テキスト
# 入力例) newConfigText1="変更後の設定テキスト"
newConfigText1="PasswordAuthentication no"
newConfigText2="PermitRootLogin no"
# sshd_configファイルのパスを設定
sshdConfigFile="/etc/ssh/sshd_config"

# 日本語ロケールをインストールする [y/n]
langJPInstall=y

#-----ファイアウォール(ufw)の開放ポート------
# 例）22, 145, 296 をポート開放 : port=(22 145 296)
port=(22)

#---------ログ設定---------------------------
mkdir logInitInstSetup
# ログの出力ディレクトリをを変更する場合は以下のLOG_OUT,LOG_ERRのパスを変更する。
LOG_OUT=./logInitInstSetup/setup1_stdout.log
LOG_ERR=./logInitInstSetup/setup1_stderr.log

exec 1> >(tee -a $LOG_OUT)
exec 2> >(tee -a $LOG_ERR)

#----------以下、実行命令----------------------------

# 実行前に最新バージョンに更新
sudo apt update
sudo apt upgrade

#日本語ロケールをインストール（yを選択した場合のみ）
if [[ $langJPInstall = [yY] ]]; then
  echo 日本語の言語パックをインストールし、ロケールを日本語へ変更します。
  sudo apt install language-pack-ja -y
  sudo localectl set-locale LANG=ja_JP.UTF-8
else
  echo 日本語の言語パックをインストールしません
fi

# 追加するユーザー名を入力
read -p "作成するユーザー名を入力 : " user
# ユーザーを追加
sudo adduser $user
# 初期ユーザーと同じグループを追加
for i in adm dialout cdrom floppy sudo audio dip video plugdev lxd netdev
do
  sudo gpasswd -a $user $i
done

# 初期ユーザーにないグループを削除
sudo gpasswd -d $user users

# sshディレクトリを再帰的に追加（追加時に権限設定をユーザーに合わせる）
sudo rsync --archive --chown=$user:$user ~/.ssh /home/$user
# sshd_configをバックアップ
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_default
# sshd_config の変更を実行
count=0
for i in ${!oldConfigText*}
do
  count=$((++count))
  sshdOldVarName="oldConfigText$count"
  sshdNewVarName="newConfigText$count"
  sudo sed -i "s/${!sshdOldVarName}/${!sshdNewVarName}/g" "$sshdConfigFile"
  echo "ファイル $sshdConfigFile の設定 ${!sshdOldVarName} を ${!sshdNewVarName} に置換しました。"
done

#sudo sed -i "s/$oldConfigText1/$newConfigText1/g" "$sshdConfigFile"
#echo "ファイル $sshdConfigFile の設定 $oldConfigText1 を $newConfigText1 に置換しました。"
#sudo sed -i "s/$oldConfigText2/$newConfigText2/g" "$sshdConfigFile"
#echo "ファイル $sshdConfigFile の設定 $oldConfigText2 を $newConfigText2 に置換しました。"

# sshdを再起動
#sudo systemctl restart sshd

# ufw(ファイアウォール)の設定
#連続アクセスを制限して各ポートのアクセスを許可（6回/30s以上でアクセス拒否）
echo "連続アクセスを制限して以下のポートのポートのアクセスを許可"
echo "（6回/30s以上でアクセス拒否）"
for i in ${!port[*]}
do
  sudo ufw limit ${port[${i}]}
  echo "${port[${i}]}"
done

#ufwを有効化
echo "ufwを有効化"
sudo ufw enable
#ufwをリロード
echo "ufwを再読み込み"
sudo ufw reload


# step1 END
echo
echo "再起動後、作成した新しいユーザーでログインし、"
echo "init_step2.sh を実行してください。"
echo
#再起動
read -p "再起動します。 OK? [y/n] " reboot
if [[ $reboot = [yY] ]]; then
  echo "再起動します..."
  sudo reboot
else
  read -p "再起動しません。手動で再起動してください。 (Press Enter)" tmpflag
fi
