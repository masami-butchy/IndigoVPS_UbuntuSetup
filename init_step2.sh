#!/bin/bash
# Step2

# このスクリプトは初期ユーザーの削除とtailscaleのインストールおよび初期設定を行います。
# !!Caution!! 実行後は初期ユーザーが消え、ログインは作成したユーザーのみ行えます！！
#             必ず init_step1.sh 実行後にこのスクリプトを実行してください。

#-----------設定----------------------------

#-------tailscale exitnode ON/OFF-------------------
#exitnodeを適用する [y/n]
exitnodeFlag=y

#---------ログ設定-------------------
mkdir logInitInstSetup
# ログの出力ディレクトリをを変更する場合は以下のLOG_OUT,LOG_ERRのパスを変更する。
LOG_OUT=./logInitInstSetup/setup1_stdout.log
LOG_ERR=./logInitInstSetup/setup1_stderr.log

exec 1> >(tee -a $LOG_OUT)
exec 2> >(tee -a $LOG_ERR)

#----------以下は実行する命令---------------

#実行前確認
read -p "init_step1.sh は実行済みですか? (実行済みの場合は処理を続けてください。) [y/n] " check
if [[ $check = [yY] ]]; then
  echo "処理を続行します。"
else
  read -p "step1が未実行のため処理を中断します。init_step1.shを実行してください。 [Press Enter] " tmpflag
  exit
fi

# 実行前に最新バージョンに更新
sudo apt update
sudo apt upgrade

# 初期ユーザー削除
sudo userdel -r ubuntu
echo "初期ユーザーを削除しました。"
echo "今後のログインは作成したユーザーで行ってください。"

# install tailscale
echo "tailscaleをインストール"
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
#tailscale 起動, 認証
if [[ $reboot = [yY] ]]; then
  echo "このサーバーをexitnodeとしてtailscaleを認証・起動"
  sudo tailscale up --advertise-exit-node
else
  echo "tailscaleを認証・起動（exitnode設定なし）"
  sudo tailscale up
fi


# 初期設定終了
echo "----------------------------------------"
echo "---------Initial setup END--------------"
echo "----------------------------------------"

echo "!!Caution!!-------------------"
echo "初期ユーザーの削除を行いました！！"
echo "ログインは作成したユーザーでログインしてください！！"

#再起動
read -p "再起動します。 OK? [y/n] " reboot
if [[ $reboot = [yY] ]]; then
  echo "reboot. 再起動します。"
  sudo reboot
else
  read -p "再起動しません。手動で再起動してください。 [Press Enter] " tmpflag
fi
